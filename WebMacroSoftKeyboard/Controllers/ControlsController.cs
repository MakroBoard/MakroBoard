using McMaster.NETCore.Plugins;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Controllers.ApiModels;
using WebMacroSoftKeyboard.Data;
using WebMacroSoftKeyboard.HubConfig;
using WebMacroSoftKeyboard.PluginContract;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace WebMacroSoftKeyboard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ControlsController : ControllerBase
    {
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ControlsController(DatabaseContext context, IHubContext<ClientHub> clientHub)
        {
            _Context = context;
            _ClientHub = clientHub;
        }

        // GET: api/client/requesttokens
        [HttpGet("availablecontrols")]
        public async Task<ActionResult> GetAvailableControls()
        {
            var pathToBinDebug = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            var pluginDir = Path.GetFullPath(Path.Combine(pathToBinDebug, "../../../../PluginOutput"));

            var loaders = new List<PluginLoader>();

            // create plugin loaders
            foreach (var dir in Directory.GetDirectories(pluginDir))
            {
                var dirName = Path.GetFileName(dir);
                var pluginDll = Path.Combine(dir, dirName + ".dll");
                if (System.IO.File.Exists(pluginDll))
                {
                    var loader = PluginLoader.CreateFromAssemblyFile(pluginDll, sharedTypes: new[] { typeof(IWebMacroSoftKeyboardPlugin) });
                    loaders.Add(loader);
                }
            }

            var plugins = new List<Plugin>();


            // Create an instance of plugin types
            foreach (var loader in loaders)
            {
                foreach (var pluginType in loader.LoadDefaultAssembly().GetTypes().Where(t => typeof(IWebMacroSoftKeyboardPlugin).IsAssignableFrom(t) && !t.IsAbstract))
                {
                    // This assumes the implementation of IPlugin has a parameterless constructor
                    var plugin = (IWebMacroSoftKeyboardPlugin)Activator.CreateInstance(pluginType);
                    var pluginControls = await plugin.GetControls().ConfigureAwait(false);
                    plugins.Add(CreatePluginModel(plugin.GetType().Name, pluginControls));
                }
            }

            return Ok(plugins);
        }


        private static Plugin CreatePluginModel(string pluginName, IEnumerable<PluginContract.Control> controls)
        {
            return new Plugin(pluginName, controls.Select(x => new ApiModels.Control(x.SymbolicName, new ApiModels.View(x.View.Type), new ApiModels.ConfigParameters(x.ConfigParameters.Select(c => CreateConfigParameter(c)).ToList()))));
        }

        private static ApiModels.ConfigParameter CreateConfigParameter(PluginContract.ConfigParameter configParameter)
        {
            return configParameter switch
            {
                StringConfigParameter scp => new ApiModels.ConfigParameter(configParameter.SymbolicName, scp.ValidationRegEx),
                IntConfigParameter icp => new ApiModels.ConfigParameter(configParameter.SymbolicName, icp.MinValue, icp.MaxValue),
                _ => throw new ArgumentOutOfRangeException(nameof(configParameter), $"ConfigParameterType {configParameter.GetType().FullName} is not yet supported!"),
            };
        }
    }
}
