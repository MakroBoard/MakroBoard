using McMaster.NETCore.Plugins;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.ActionFilters;
using WebMacroSoftKeyboard.Controllers.ApiModels;
using WebMacroSoftKeyboard.Data;
using WebMacroSoftKeyboard.HubConfig;
using WebMacroSoftKeyboard.PluginContract;
using WebMacroSoftKeyboard.PluginContract.Parameters;
using WebMacroSoftKeyboard.PluginContract.Views;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace WebMacroSoftKeyboard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LayoutController : ControllerBase
    {
        private readonly ILogger<LayoutController> _logger;
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public LayoutController(ILogger<LayoutController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub)
        {
            _logger = logger;
            _Context = context;
            _ClientHub = clientHub;
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpage")]
        [LocalHost]
        public async Task<ActionResult> PostAddPAge([FromBody] ApiModels.Page client)
        {
            var newPage = new Data.Page
            {
                SymbolicName = Regex.Replace(client.Label, @"\s+", "-").ToLower(),
                Label = client.Label,
                Icon = client.Icon
            };
            _Context.Pages.Add(newPage);

            await _Context.SaveChangesAsync();
            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, newPage);
            return Ok();
        }
    }
}
