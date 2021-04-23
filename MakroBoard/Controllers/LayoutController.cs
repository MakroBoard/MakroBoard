using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using MakroBoard.ActionFilters;
using MakroBoard.Data;
using MakroBoard.HubConfig;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
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
        public async Task<ActionResult> PostAddPAge([FromBody] ApiModels.Page page)
        {
            var newPage = new Data.Page
            {
                SymbolicName = ConvertToSymbolicName(page.Label),
                Label = page.Label,
                Icon = page.Icon,
                Groups = new List<Data.Group>()
            };
            _Context.Pages.Add(newPage);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Page {newPage.Label}");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, newPage);
            return Ok();
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addgroup")]
        [LocalHost]
        public async Task<ActionResult> PostAddGroup([FromBody] ApiModels.Group group)
        {
            var newGroup = new Data.Group
            {
                SymbolicName = ConvertToSymbolicName(group.Label),
                Label = group.Label,
                PageID = group.PageID
            };
            _Context.Groups.Add(newGroup);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Group {newGroup.Label}");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup);
            return Ok();
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpanel")]
        [LocalHost]
        public async Task<ActionResult> PostAddPanel([FromBody] ApiModels.Panel panel)
        {
            var newPanel = new Data.Panel
            {
                SymbolicName = panel.SymbolicName,
                PluginName = panel.PluginName,
                GroupID = panel.GroupId                
            };

            newPanel.ConfigParameters = panel.ConfigValues.Select(x => new Data.ConfigParameterValue
            {
                SymbolicName = x.SymbolicName,
                Value = x.Value?.ToString(),
                Panel = newPanel,
            }).ToList();

            _Context.Panels.Add(newPanel);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Panel {newPanel.SymbolicName}({newPanel.PluginName})");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, newPanel);
            return Ok();
        }

        private static string ConvertToSymbolicName(string name)
        {
            return Regex.Replace(name, @"\s+", "-").ToLower();
        }
    }
}
