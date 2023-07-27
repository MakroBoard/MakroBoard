using MakroBoard.Controllers;
using MakroBoard.ApiModels;
using MakroBoard.HubConfig;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using McMaster.NETCore.Plugins;
using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.SignalR.Client;
using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using System.Globalization;

namespace MakroBoard.Plugin
{
    public class PluginContext
    {
        private static readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private readonly IHubContext<ClientHub> _HubContext;

        public PluginContext(IHubContext<ClientHub> hubContext)
        {
            _HubContext = hubContext;
        }

        public IList<IMakroBoardPlugin> Plugins { get; private set; }

        public Task InitializePlugins()
        {
            var pathToBinDebug = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

            var pluginDir = Path.GetFullPath("Plugins");
            if (!Directory.Exists(pluginDir))
            {
                pluginDir = Path.GetFullPath(Path.Combine(pathToBinDebug, "../../../../PluginOutput"));
            }

            _Logger.Info($"Using PluginDirectory: \"{pluginDir}\"");

            var loaders = new List<PluginLoader>();

            // create plugin loaders            
            foreach (var dir in Directory.GetDirectories(pluginDir))
            {
                var dirName = Path.GetFileName(dir);
                var pluginDll = Path.Combine(dir, dirName + ".dll");
                if (File.Exists(pluginDll))
                {
                    var loader = PluginLoader.CreateFromAssemblyFile(pluginDll, sharedTypes: new[] { typeof(IMakroBoardPlugin) });
                    loaders.Add(loader);
                }
            }

            var plugins = new List<IMakroBoardPlugin>();



            try
            {  // Create an instance of plugin types
                foreach (var loader in loaders)
                {
                    foreach (var pluginType in loader.LoadDefaultAssembly().GetTypes().Where(t => typeof(IMakroBoardPlugin).IsAssignableFrom(t) && !t.IsAbstract))
                    {
                        try
                        {
                            _Logger.Info($"Loading Plugin {pluginType.Name}");
                            // This assumes the implementation of IPlugin has a parameterless constructor
                            var plugin = (IMakroBoardPlugin)Activator.CreateInstance(pluginType);
                            plugin.Initialize();
                            plugins.Add(plugin);
                        }
                        catch (Exception e)
                        {
                            _Logger.Error(e, $"Error Loading Plugin {pluginType.Name}");
                        }
                    }
                }
            }
            catch (Exception e)
            {
                _Logger.Error(e, "Error Loading Plugins");
            }

            Plugins = plugins;

            return Task.CompletedTask;
        }

        public void Subscribe(int panelId, PluginContract.Control control, ParameterValues parameterValues)
        {
            control.Subscribe(parameterValues, panelId, OnControlChanged);
        }

        public async Task Subscribe(int panelId, string pluginName, string controlName, IReadOnlyDictionary<string, string> configParameters)
        {
            var plugin = Plugins.First(x => x.SymbolicName.Equals(pluginName, StringComparison.OrdinalIgnoreCase));
            var control = await plugin.GetControl(controlName).ConfigureAwait(false);

            control.Subscribe(CreateParameterValues(control, configParameters), panelId, OnControlChanged);
        }

        private static ParameterValues CreateParameterValues(PluginContract.Control control, IReadOnlyDictionary<string, string> configParameters)
        {
            var parameterValues = new ParameterValues();

            foreach (var configParameter in configParameters)
            {
                var controlConfigParameter = control.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.Key, StringComparison.OrdinalIgnoreCase)) ?? control.View.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.Key, StringComparison.OrdinalIgnoreCase)) ?? control.View.PluginParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.Key, StringComparison.OrdinalIgnoreCase));
                switch (controlConfigParameter)
                {
                    case IntConfigParameter icp:
                        parameterValues.Add(new IntParameterValue(icp, int.Parse(configParameter.Value, CultureInfo.InvariantCulture)));
                        break;
                    case StringConfigParameter scp:
                        parameterValues.Add(new StringParameterValue(scp, configParameter.Value));
                        break;
                    case BoolConfigParameter bcp:
                        parameterValues.Add(new BoolParameterValue(bcp, configParameter.Value != null ? bool.Parse(configParameter.Value) : bcp.DefaultValue));
                        break;
                    default:
                        throw new NotSupportedException($"{controlConfigParameter?.GetType().Name} is not yet implemented!");
                }
            }

            foreach (var pluginParameter in control.View.PluginParameters)
            {
                switch (pluginParameter)
                {
                    case IntConfigParameter icp:
                        parameterValues.Add(new IntParameterValue(icp, icp.DefaultValue));
                        break;
                    case StringConfigParameter scp:
                        parameterValues.Add(new StringParameterValue(scp, scp.DefaultValue));
                        break;
                    case BoolConfigParameter bcp:
                        parameterValues.Add(new BoolParameterValue(bcp, bcp.DefaultValue));
                        break;
                    default:
                        throw new NotSupportedException($"{pluginParameter.GetType().Name} is not yet implemented!");
                }
            }

            return parameterValues;
        }

        private void OnControlChanged(PanelChangedEventArgs panelChangedEventArgs)
        {
            _ = _HubContext.Clients.All.SendAsync(ClientMethods.UpdatePanelData, new PanelData(panelChangedEventArgs.PanelId, panelChangedEventArgs.Control.SymbolicName, panelChangedEventArgs.ParameterValues.Select(x => new ConfigValue(x.ConfigParameter.SymbolicName, x.UntypedValue)).ToList()));
        }
    }
}
