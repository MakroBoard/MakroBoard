//using MakroBoard.PluginContract;
//using MakroBoard.PluginContract.Parameters;
//using McMaster.NETCore.Plugins;
//using Microsoft.AspNetCore.SignalR;
//using Microsoft.AspNetCore.SignalR.Client;
//using NLog;
//using System;
//using System.Collections.Generic;
//using System.IO;
//using System.Linq;
//using System.Reflection;
//using System.Threading.Tasks;

//namespace MakroBoard.Plugin
//{
//    public class PluginContext
//    {
//        private static ILogger _Logger = LogManager.GetCurrentClassLogger();
//        private HubConnection _Connection;

//        public PluginContext()
//        {
//            _Connection = new HubConnectionBuilder()
//                .WithUrl("https://localhost:5001/hub/clients")
//                .WithAutomaticReconnect()
//                .Build();
//        }

//        public IList<IMakroBoardPlugin> Plugins { get; private set; }

//        public async Task InitializePlugins()
//        {
//            var pathToBinDebug = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
//            var pluginDir = Path.GetFullPath(Path.Combine(pathToBinDebug, "../../../../PluginOutput"));

//            var loaders = new List<PluginLoader>();

//            // create plugin loaders            
//            foreach (var dir in Directory.GetDirectories(pluginDir))
//            {
//                var dirName = Path.GetFileName(dir);
//                var pluginDll = Path.Combine(dir, dirName + ".dll");
//                if (File.Exists(pluginDll))
//                {
//                    var loader = PluginLoader.CreateFromAssemblyFile(pluginDll, sharedTypes: new[] { typeof(IMakroBoardPlugin) });
//                    loaders.Add(loader);
//                }
//            }

//            var plugins = new List<IMakroBoardPlugin>();


//            // Create an instance of plugin types
//            foreach (var loader in loaders)
//            {
//                foreach (var pluginType in loader.LoadDefaultAssembly().GetTypes().Where(t => typeof(IMakroBoardPlugin).IsAssignableFrom(t) && !t.IsAbstract))
//                {
//                    _Logger.Info($"Loading Plugin {pluginType.Name}");
//                    // This assumes the implementation of IPlugin has a parameterless constructor
//                    plugins.Add((IMakroBoardPlugin)Activator.CreateInstance(pluginType));
//                }
//            }

//            Plugins = plugins;

//            await Task.CompletedTask;
//        }
    
//        public void Subscribe(int panelId, Control control, ParameterValues parameterValues)
//        {
//            control.Subscribe(parameterValues, panelId, OnControlChanged);

//        }

//        private void OnControlChanged(PanelChangedEventArgs obj)
//        {
//            _ = _Connection.SendAsync("ServerPanelChangedEventArgs", obj);
//        }
//    }
//}
