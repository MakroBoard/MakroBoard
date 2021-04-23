using McMaster.NETCore.Plugins;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text.Json;
using System.Threading.Tasks;
using MakroBoard.ActionFilters;
using MakroBoard.Controllers.ApiModels;
using MakroBoard.Data;
using MakroBoard.HubConfig;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;

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
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ControlsController(ILogger<ControlsController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub)
        {
            _logger = logger;
            _Context = context;
            _ClientHub = clientHub;
        }

        // GET: api/client/requesttokens
        [HttpGet("availablecontrols")]
        [LocalHost]
        public async Task<ActionResult> GetAvailableControls()
        {
            var plugins = await LoadAllPlugins().ConfigureAwait(false);

            var result = new List<Plugin>();
            foreach (var plugin in plugins)
            {
                var pluginControls = await plugin.GetControls().ConfigureAwait(false);
                result.Add(CreatePluginModel(plugin.GetType().Name, pluginControls));
            }

            return Ok(result);
        }

        private static async Task<List<IMakroBoardPlugin>> LoadAllPlugins()
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
                    var loader = PluginLoader.CreateFromAssemblyFile(pluginDll, sharedTypes: new[] { typeof(IMakroBoardPlugin) });
                    loaders.Add(loader);
                }
            }

            var plugins = new List<IMakroBoardPlugin>();


            // Create an instance of plugin types
            foreach (var loader in loaders)
            {
                foreach (var pluginType in loader.LoadDefaultAssembly().GetTypes().Where(t => typeof(IMakroBoardPlugin).IsAssignableFrom(t) && !t.IsAbstract))
                {
                    // This assumes the implementation of IPlugin has a parameterless constructor
                    plugins.Add((IMakroBoardPlugin)Activator.CreateInstance(pluginType));
                }
            }

            return plugins;
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

            var plugins = await LoadAllPlugins().ConfigureAwait(false);
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
                                var cv = new PluginContract.ConfigValues();
                                foreach (var c in configValues)
                                {
                                    if (c.Value is JsonElement jsonElement)
                                    {
                                        var configParameter = control.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(c.SymbolicName, StringComparison.OrdinalIgnoreCase));
                                        switch (configParameter)
                                        {
                                            case StringConfigParameter scp:
                                                cv.Add(new PluginContract.ConfigValue(c.SymbolicName, jsonElement.GetString()));
                                                break;
                                            case BoolConfigParameter bcp:
                                                cv.Add(new PluginContract.ConfigValue(c.SymbolicName, jsonElement.GetBoolean()));
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
                                        cv.Add(new PluginContract.ConfigValue(c.SymbolicName, c.Value));
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


        private static Plugin CreatePluginModel(string pluginName, IEnumerable<PluginContract.Control> controls)
        {
            return new Plugin(pluginName, controls.Select(x => new ApiModels.Control(x.SymbolicName, new ApiModels.View(x.View.Type.ToString(), new ApiModels.ConfigParameters(x.View.ConfigParameters.Select(c => CreateConfigParameter(c)).ToList())), new ApiModels.ConfigParameters(x.ConfigParameters.Select(c => CreateConfigParameter(c)).ToList()))));
        }

        private static ApiModels.ConfigParameter CreateConfigParameter(PluginContract.Parameters.ConfigParameter configParameter)
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
