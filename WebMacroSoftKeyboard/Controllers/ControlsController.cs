using McMaster.NETCore.Plugins;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
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
        private readonly ClientContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ControlsController(ClientContext context, IHubContext<ClientHub> clientHub)
        {
            _Context = context;
            _ClientHub = clientHub;
        }

        // GET: api/client/requesttokens
        [HttpGet("controls")]
        public async Task<ActionResult> GetControls()
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

            var controls = new List<Control>();


            // Create an instance of plugin types
            foreach (var loader in loaders)
            {
                foreach (var pluginType in loader.LoadDefaultAssembly().GetTypes().Where(t => typeof(IWebMacroSoftKeyboardPlugin).IsAssignableFrom(t) && !t.IsAbstract))
                {
                    // This assumes the implementation of IPlugin has a parameterless constructor
                    var plugin = (IWebMacroSoftKeyboardPlugin)Activator.CreateInstance(pluginType);
                    var cs = await plugin.GetControls().ConfigureAwait(false);
                    controls.AddRange(cs);
                }
            }

            return Ok(controls);
        }
    }
}
