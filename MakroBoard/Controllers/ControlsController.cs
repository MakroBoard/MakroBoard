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

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ControlsController : ControllerBase
    {
        private readonly ILogger<ControlsController> _logger;
        private readonly PluginContext _PluginContext;

        public ControlsController(ILogger<ControlsController> logger, PluginContext pluginContext)
        {
            _logger = logger;
            _PluginContext = pluginContext;
        }

        // GET: api/client/requesttokens
        [HttpGet("availablecontrols")]
        //[ServiceFilter(typeof(AuthenticatedAdmin))]
        [ServiceFilter(typeof(AuthenticatedClient))]
        public async Task<ActionResult<AvailableControlsResponse>> GetAvailableControls()
        {
            var plugins = _PluginContext.Plugins;

            var result = new List<MakroBoard.ApiModels.Plugin>();
            foreach (var plugin in plugins)
            {
                var pluginControls = await plugin.GetControls().ConfigureAwait(false);
                result.Add(CreatePluginModel(plugin.SymbolicName, pluginControls));
            }

            return Ok(new AvailableControlsResponse(result));
        }



        /// <summary>
        /// POST: api/controls/confirmclient
        /// </summary>
        [HttpPost("execute")]
        [ServiceFilter(typeof(AuthenticatedClient))]
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
                                                cv.Add(new StringParameterValue(scp, jsonElement.GetString()));
                                                break;
                                            case BoolConfigParameter bcp:
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
                                                        cv.Add(new BoolParameterValue(bcp, true));
                                                        break;
                                                    case JsonValueKind.False:
                                                        cv.Add(new BoolParameterValue(bcp, false));
                                                        break;
                                                    case JsonValueKind.Null:
                                                        break;
                                                }
                                                break;
                                            case null:
                                                // ignore Parameter
                                                break;
                                            default:
                                                throw new NotSupportedException("This is not yet supported!");
                                        }
                                    }
                                    else
                                    {
                                        //cv.Add(new StringC(c.SymbolicName, c.Value));
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
                    _logger.LogError($"Failed to execute: { e.Message }");

                    return Ok(new ExecuteResponse(string.Empty) { Status = ResponseStatus.Error, Error = $"Failed to execute: { e.Message }" });
                }
            }
   
            return Ok(new ExecuteResponse(result));
        }


        private static MakroBoard.ApiModels.Plugin CreatePluginModel(string pluginName, IEnumerable<PluginContract.Control> controls)
        {
            return new ApiModels.Plugin(pluginName, controls.Select(x => new ApiModels.Control(x.SymbolicName,
                new ApiModels.View(x.View.Type.ToString(), ToApiConfigParameters(x.View.ConfigParameters), ToApiConfigParameters(x.View.PluginParameters)),
                ToApiConfigParameters(x.ConfigParameters))));
        }

        private static MakroBoard.ApiModels.ConfigParameters ToApiConfigParameters(PluginContract.Parameters.ConfigParameters configParameters)
        {
            return new ApiModels.ConfigParameters(configParameters.Select(c => CreateConfigParameter(c)).ToList());
        }

        private static MakroBoard.ApiModels.ConfigParameter CreateConfigParameter(PluginContract.Parameters.ConfigParameter configParameter)
        {
            return configParameter switch
            {
                StringConfigParameter scp => new ApiModels.ConfigParameter(configParameter.SymbolicName, scp.DefaultValue, scp.ValidationRegEx),
                IntConfigParameter icp => new ApiModels.ConfigParameter(configParameter.SymbolicName, icp.MinValue, icp.MaxValue),
                BoolConfigParameter bcp => new ApiModels.ConfigParameter(configParameter.SymbolicName, bcp.DefaultValue),
                _ => throw new ArgumentOutOfRangeException(nameof(configParameter), $"ConfigParameterType {configParameter.GetType().FullName} is not yet supported!"),
            };
        }
    }
}
