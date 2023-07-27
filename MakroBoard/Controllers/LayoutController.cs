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
using MakroBoard.Plugin;
using Microsoft.EntityFrameworkCore;
using MakroBoard.ApiModels;
using System;
using System.Globalization;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public partial class LayoutController : ControllerBase
    {
        private readonly ILogger<LayoutController> _logger;
        private readonly DatabaseContext _Context;
        private readonly PluginContext _PluginContext;
        private readonly IHubContext<ClientHub> _ClientHub;


        public LayoutController(ILogger<LayoutController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub, PluginContext pluginContext)
        {
            _logger = logger;
            _Context = context;
            _ClientHub = clientHub;
            _PluginContext = pluginContext;
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddPageResponse>> PostAddPAge([FromBody] AddPageRequest addPageRequest)
        {
            var newPage = new Data.Page
            {
                SymbolicName = ConvertToSymbolicName(addPageRequest.Page.Label),
                Label = addPageRequest.Page.Label,
                Icon = addPageRequest.Page.Icon,
                Groups = new List<Data.Group>(),
            };
            _Context.Pages.Add(newPage);

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Added new Page {Label}", newPage.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, newPage);
            return Ok(new AddPageResponse());
        }


        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("editpage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<EditPageResponse>> PostEditPage([FromBody] EditPageRequest editPageRequest)
        {
            var existingPage = await _Context.Pages.Where(x => x.ID == editPageRequest.Page.Id).Include(x => x.Groups).ThenInclude(g => g.Panels).ThenInclude(p => p.ConfigParameters).FirstOrDefaultAsync();
            if (existingPage == null)
            {
                return Conflict(new EditPageResponse { Status = ResponseStatus.Error, Error = "Page to edit not found" });
            }

            existingPage.Label = editPageRequest.Page.Label;
            existingPage.Icon = editPageRequest.Page.Icon;

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Edit Page {ID} => {Label}", existingPage.ID, existingPage.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, existingPage);

            return Ok(new AddPanelResponse());
        }

        [HttpPost("removepage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemovePageResponse>> PostRemovePage([FromBody] RemovePageRequest removePanelRequest)
        {
            // Include Panels to cascade delete 
            var pageToDelete = await _Context.Pages.Where(x => x.ID == removePanelRequest.PageId).Include(x => x.Groups).ThenInclude(g => g.Panels).FirstOrDefaultAsync();
            if (pageToDelete == null)
            {
                return NotFound(new RemovePageResponse { Status = ResponseStatus.Error, Error = "Page to delete not found" });
            }

            _Context.Pages.Remove(pageToDelete);
            await _Context.SaveChangesAsync();

            _logger.LogDebug("Removed Page {Label}", pageToDelete.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemovePage, pageToDelete);
            return Ok(new RemovePanelResponse());
        }


        /// <summary>
        /// POST: api/layout/addgroup
        /// </summary>
        [HttpPost("addgroup")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddGroupResponse>> PostAddGroup([FromBody] ApiModels.AddGroupRequest addGroupRequest)
        {
            var newGroup = new Data.Group
            {
                SymbolicName = ConvertToSymbolicName(addGroupRequest.Group.Label),
                Label = addGroupRequest.Group.Label,
                PageID = addGroupRequest.Group.PageID,
            };
            _Context.Groups.Add(newGroup);

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Added new Group {Label}", newGroup.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup);
            return Ok(new AddGroupResponse());
        }

        /// <summary>
        /// POST: api/layout/editgroup
        /// </summary>
        [HttpPost("editgroup")]
        [LocalHost]
        public async Task<ActionResult<EditGroupResponse>> PostEditGroup([FromBody] EditGroupRequest editGroupRequest)
        {
            var newGroup = _Context.Groups.Find(editGroupRequest.Group.Id);
            newGroup.Label = editGroupRequest.Group.Label;

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Group {Label} edited", newGroup.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup);
            return Ok(new EditGroupResponse());
        }

        [HttpPost("removegroup")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemoveGroupResponse>> PostRemoveGroup([FromBody] RemoveGroupRequest removeGroupRequest)
        {
            // Include Panels to cascade delete 
            var groupToDelete = await _Context.Groups.Where(x => x.ID == removeGroupRequest.GroupId).Include(x => x.Panels).FirstOrDefaultAsync();
            if (groupToDelete == null)
            {
                return NotFound(new RemoveGroupResponse { Status = ResponseStatus.Error, Error = "Group to delete not found" });
            }

            _Context.Groups.Remove(groupToDelete);
            await _Context.SaveChangesAsync();

            _logger.LogDebug("Removed Group {Label}", groupToDelete.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemoveGroup, groupToDelete);
            return Ok(new RemoveGroupResponse());
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddPanelResponse>> PostAddPanel([FromBody] AddPanelRequest addPanelRequest)
        {
            var newPanel = new Data.Panel
            {
                SymbolicName = addPanelRequest.Panel.SymbolicName,
                PluginName = addPanelRequest.Panel.PluginName,
                GroupId = addPanelRequest.Panel.GroupId,
            };

            newPanel.ConfigParameters = addPanelRequest.Panel.ConfigValues.Select(x => new Data.ConfigParameterValue
            {
                SymbolicName = x.SymbolicName,
                Value = x.Value?.ToString(),
                Panel = newPanel,
            }).ToList();

            _Context.Panels.Add(newPanel);

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Added new Panel {SymbolicName}({PluginName})", newPanel.SymbolicName, newPanel.PluginName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, newPanel);

            await _PluginContext.Subscribe(newPanel.ID, addPanelRequest.Panel.PluginName, addPanelRequest.Panel.SymbolicName, newPanel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value, StringComparer.Ordinal));

            return Ok(new AddPanelResponse());
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("editpanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<EditPanelResponse>> PostEditPanel([FromBody] EditPanelRequest editPanelRequest)
        {
            // Include Panels to cascade delete 
            var existingPanel = await _Context.Panels.Where(x => x.ID == editPanelRequest.Panel.ID).Include(x => x.ConfigParameters).FirstOrDefaultAsync();
            if (existingPanel == null)
            {
                return NotFound(new RemovePanelResponse { Status = ResponseStatus.Error, Error = "Panel to edit not found" });
            }

            existingPanel.SymbolicName = editPanelRequest.Panel.SymbolicName;
            existingPanel.GroupId = editPanelRequest.Panel.GroupId;
            existingPanel.ConfigParameters.ForEach(cp =>
            {
                cp.Value = editPanelRequest.Panel.ConfigValues.Find(x => x.SymbolicName.Equals(cp.SymbolicName, StringComparison.Ordinal))?.Value?.ToString() ?? cp.Value;
            });

            await _Context.SaveChangesAsync();

            _logger.LogDebug("Edit Panel {ID} => {SymbolicName}({PluginName})", existingPanel.ID, existingPanel.SymbolicName, existingPanel.PluginName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, existingPanel).ConfigureAwait(false);

            await _PluginContext.Subscribe(existingPanel.ID, existingPanel.PluginName, existingPanel.SymbolicName, existingPanel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value, StringComparer.Ordinal)).ConfigureAwait(false);

            return Ok(new AddPanelResponse());
        }

        [HttpPost("removepanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemovePanelResponse>> PostRemovePanel([FromBody] RemovePanelRequest removePanelRequest)
        {
            // Include Panels to cascade delete 
            var panelToDelete = await _Context.Panels.Where(x => x.ID == removePanelRequest.PanelId).FirstOrDefaultAsync().ConfigureAwait(false);
            if (panelToDelete == null)
            {
                return NotFound(new RemovePanelResponse { Status = ResponseStatus.Error, Error = "Panel to delete not found" });
            }

            _Context.Panels.Remove(panelToDelete);
            await _Context.SaveChangesAsync().ConfigureAwait(false);

            _logger.LogDebug("Removed Panel {Label}", panelToDelete.SymbolicName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemovePanel, panelToDelete).ConfigureAwait(false);
            return Ok(new RemovePanelResponse());
        }

        private static string ConvertToSymbolicName(string name)
        {
            return ConvertToSymbolicNameRegEx().Replace(name, "-").ToLower(CultureInfo.InvariantCulture);
        }

        [GeneratedRegex(@"\s+", RegexOptions.None, matchTimeoutMilliseconds: 1000)]
        private static partial Regex ConvertToSymbolicNameRegEx();
    }
}
