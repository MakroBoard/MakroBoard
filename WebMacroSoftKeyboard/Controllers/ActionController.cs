using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Prise;
using System.Collections.Generic;
using System.IO;
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
    public class ActionController : ControllerBase
    {
        private readonly ClientContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;
        private readonly IPluginLoader _ActionPluginLoader;

        public ActionController(ClientContext context, IHubContext<ClientHub> clientHub, IPluginLoader actionPluginLoader)
        {
            _Context = context;
            _ClientHub = clientHub;
            _ActionPluginLoader = actionPluginLoader;
        }

        // GET: api/client/requesttokens
        [HttpGet("controls")]
        public async Task<ActionResult> GetControls()
        {
            // pathToBinDebug = Weather.Api/bin/Debug/netcoreapp3.1
            var pathToBinDebug = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            // pathToDist = _dist
            var pathToDist = Path.GetFullPath("../../../../_dist", pathToBinDebug);
            // scanResult should contain the information about the OpenWeather.Plugin
            var scanResult = await _ActionPluginLoader.FindPlugin<IWebMacroSoftKeyboardPlugin>(pathToDist);

            if (scanResult == null)
            {
                //_logger.LogWarning($"No plugin was found for type {typeof(IWeatherPlugin).Name}");
                return NoContent();
            }

            // Load the IWeatherPlugin
            var plugins = await _ActionPluginLoader.LoadPlugins<IWebMacroSoftKeyboardPlugin>(scanResult);
            var controls = new List<Control>();
            foreach (var plugin in plugins)
            {
                controls.AddRange(await plugin.GetControls());
            }
            return Ok(controls);
        }
    }
}
