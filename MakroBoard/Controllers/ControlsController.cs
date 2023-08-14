using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using MakroBoard.ActionFilters;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using MakroBoard.Plugin;
using MakroBoard.ApiModels;
using MakroBoard.Extensions;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ControlsController : ControllerBase
    {
        private readonly ILogger<ControlsController> _Logger;
        private readonly PluginContext _PluginContext;

        public ControlsController(ILogger<ControlsController> logger, PluginContext pluginContext)
        {
            _Logger = logger;
            _PluginContext = pluginContext;
        }

        // GET: api/client/requesttokens
        [HttpGet("availablecontrols")]
        //[ServiceFilter(typeof(AuthenticatedAdmin))]
        //[ServiceFilter(typeof(AuthenticatedClientAttribute))]
        public async Task<ActionResult<AvailableControlsResponse>> GetAvailableControls()
        {
            var plugins = _PluginContext.Plugins;

            var result = new List<MakroBoard.ApiModels.Plugin>();
            foreach (var plugin in plugins)
            {
                var pluginControls = await plugin.GetControls().ConfigureAwait(false);
                result.Add(plugin.ToApiPlugin(pluginControls));
            }

            return Ok(new AvailableControlsResponse(result));
        }

        [HttpGet("{pluginName}/image/{imageName}")]
        public async Task<ActionResult> GetImage([FromRoute] string pluginName, [FromRoute] string imageName)
        {
            var plugin = _PluginContext.Plugins.FirstOrDefault(x => x.SymbolicName.Equals(pluginName, StringComparison.OrdinalIgnoreCase));
            if (plugin == null)
            {
                _Logger.LogError("Failed to load image. Plugin {pluginName} not found", pluginName);
                return Ok(new ExecuteResponse(string.Empty) { Status = ResponseStatus.Error, Error = $"Failed to load image. Plugin {pluginName} not found" });
            }

            var imageData = plugin.LoadImage(imageName);
            if (imageData == null)
            {
                _Logger.LogError("Failed to load image. Image {imageName} not found", imageName);
                return Ok(new ExecuteResponse(string.Empty) { Status = ResponseStatus.Error, Error = $"Failed to load image. Image {imageName} not found" });
            }

            var contentType = imageData.FileType.Trim('.');
            if (contentType.Equals("svg", StringComparison.OrdinalIgnoreCase))
            {
                contentType += "+xml";
            }
            return base.File(imageData.Data, $"image/{contentType}");
        }

        /// <summary>
        /// POST: api/controls/confirmclient
        /// </summary>
        [HttpPost("execute")]
        [ServiceFilter(typeof(AuthenticatedClientAttribute))]
        public async Task<ActionResult<ExecuteResponse>> PostExecute([FromBody] ExecuteRequest executeRequest)
        {
            var plugins = _PluginContext.Plugins;
            string result = string.Empty;
            foreach (var plugin in plugins)
            {
                try
                {
                    // TODO Better Plugin/Control Loading
                    var control = await plugin.GetControl(executeRequest.SymbolicName);
                    if (control != null)
                    {
                        switch (control.View)
                        {
                            case ButtonView bv:
                                var cv = new ParameterValues();
                                foreach (var c in executeRequest.ConfigValues)
                                {
                                    if (c.Value is JsonElement jsonElement)
                                    {
                                        var configParameter = control.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(c.SymbolicName, StringComparison.OrdinalIgnoreCase));
                                        switch (configParameter)
                                        {
                                            case StringConfigParameter scp:
                                                LoadStringConfigParameter(cv, jsonElement, scp);
                                                break;
                                            case BoolConfigParameter bcp:
                                                LoadBoolConfigParameter(cv, jsonElement, bcp);
                                                break;
                                            case null:
                                                // ignore Parameter
                                                break;
                                            default:
                                                throw new NotSupportedException("This is not yet supported!");
                                        }
                                    }
                                }
                                result = bv.Execute(cv);
                                break;
                            default:
                                throw new NotSupportedException($"ViewType {control.View.GetType().Name} is not yet implemented.");
                        }

                        break;
                    }

                }
                catch (Exception e)
                {
                    _Logger.LogError(e, "Failed to execute: {message}", e.Message);

                    return Ok(new ExecuteResponse(string.Empty) { Status = ResponseStatus.Error, Error = $"Failed to execute: {e.Message}" });
                }
            }

            return Ok(new ExecuteResponse(result));
        }

        private static void LoadStringConfigParameter(ParameterValues cv, JsonElement jsonElement, StringConfigParameter scp)
        {
            cv.Add(new StringParameterValue(scp, jsonElement.GetString()));
        }

        private static void LoadBoolConfigParameter(ParameterValues cv, JsonElement jsonElement, BoolConfigParameter bcp)
        {
            switch (jsonElement.ValueKind)
            {
                case JsonValueKind.Undefined:
                    break;
                case JsonValueKind.Object:
                    break;
                case JsonValueKind.Array:
                    break;
                case JsonValueKind.String:
                    cv.Add(new BoolParameterValue(bcp, bool.Parse(jsonElement.GetString())));
                    break;
                case JsonValueKind.Number:
                    cv.Add(new BoolParameterValue(bcp, jsonElement.GetInt32() > 0));
                    break;
                case JsonValueKind.True:
                    cv.Add(new BoolParameterValue(bcp, value: true));
                    break;
                case JsonValueKind.False:
                    cv.Add(new BoolParameterValue(bcp, value: false));
                    break;
                case JsonValueKind.Null:
                    break;
            }
        }
    }
}
