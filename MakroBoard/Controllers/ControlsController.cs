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
        [LocalHost]
        public async Task<ActionResult> GetAvailableControls()
        {
            var plugins = _PluginContext.Plugins;

            var result = new List<ApiModels.Plugin>();
            foreach (var plugin in plugins)
            {
                var pluginControls = await plugin.GetControls().ConfigureAwait(false);
                result.Add(CreatePluginModel(plugin.SymbolicName, pluginControls));
            }

            return Ok(result);
        }



        /// <summary>
        /// POST: api/controls/confirmclient
        /// </summary>
        [HttpPost("execute")]
        [LocalHost]
        public async Task<ActionResult> PostExecute([FromBody] JsonElement data)
        {
            var symbolicName = string.Empty;
            ApiModels.ConfigValues configValues = null;
            foreach (var element in data.EnumerateObject())
            {
                switch (element.Name)
                {
                    case "symbolicName":
                        symbolicName = element.Value.GetString();
                        break;
                    case "configValues":
                        var json = element.Value.GetRawText();
                        // TODO Deseriaize
                        configValues = JsonSerializer.Deserialize<ApiModels.ConfigValues>(json, new JsonSerializerOptions
                        {
                            PropertyNameCaseInsensitive = true,
                        });
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(data), $"Data Property {element.Name} is not yet implemented!");
                }
            }

            var plugins = _PluginContext.Plugins;
            foreach (var plugin in plugins)
            {
                try
                {
                    var control = await plugin.GetControl(symbolicName);
                    if (control != null)
                    {
                        switch (control.View)
                        {
                            case ButtonView bv:
                                var cv = new ParameterValues();
                                foreach (var c in configValues)
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
                                bv.Execute(cv);
                                break;
                            default:
                                throw new NotSupportedException($"ViewType {control.View.GetType().Name} is not yet implemented.");
                        }
                    }

                }
                catch (Exception e)
                {
                    _logger.LogError($"Failed to execute: { e.Message }");
                }
            }
            //var control = plugins.SelectMany(x => x.Controls).FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, StringComparison.OrdinalIgnoreCase));
            //if (control == null)
            //{
            //    return StatusCode(418);
            //}

            return Ok();
        }


        private static ApiModels.Plugin CreatePluginModel(string pluginName, IEnumerable<PluginContract.Control> controls)
        {
            return new ApiModels.Plugin(pluginName, controls.Select(x => new ApiModels.Control(x.SymbolicName,
                new ApiModels.View(x.View.Type.ToString(), ToApiConfigParameters(x.View.ConfigParameters), ToApiConfigParameters(x.View.PluginParameters)),
                ToApiConfigParameters(x.ConfigParameters))));
        }

        private static ApiModels.ConfigParameters ToApiConfigParameters(ConfigParameters configParameters)
        {
            return new ApiModels.ConfigParameters(configParameters.Select(c => CreateConfigParameter(c)).ToList());
        }

        private static ApiModels.ConfigParameter CreateConfigParameter(ConfigParameter configParameter)
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
