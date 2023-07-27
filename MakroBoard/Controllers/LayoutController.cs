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
using System.Threading;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public partial class LayoutController : ControllerBase
    {
        private readonly ILogger<LayoutController> _Logger;
        private readonly DatabaseContext _Context;
        private readonly PluginContext _PluginContext;
        private readonly IHubContext<ClientHub> _ClientHub;


        public LayoutController(ILogger<LayoutController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub, PluginContext pluginContext)
        {
            _Logger = logger;
            _Context = context;
            _ClientHub = clientHub;
            _PluginContext = pluginContext;
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddPageResponse>> PostAddPAge([FromBody] AddPageRequest addPageRequest, CancellationToken cancellationToken)
        {
            var newPage = new Data.Page
            {
                SymbolicName = ConvertToSymbolicName(addPageRequest.Page.Label),
                Label = addPageRequest.Page.Label,
                Icon = addPageRequest.Page.Icon,
                Groups = new List<Data.Group>(),
            };
            _Context.Pages.Add(newPage);

            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Added new Page {Label}", newPage.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, newPage, cancellationToken);
            return Ok(new AddPageResponse());
        }


        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("editpage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<EditPageResponse>> PostEditPage([FromBody] EditPageRequest editPageRequest, CancellationToken cancellationToken)
        {
            var existingPage = await _Context.Pages.Where(x => x.ID == editPageRequest.Page.Id).Include(x => x.Groups).ThenInclude(g => g.Panels).ThenInclude(p => p.ConfigParameters).FirstOrDefaultAsync(cancellationToken);
            if (existingPage == null)
            {
                return Conflict(new EditPageResponse { Status = ResponseStatus.Error, Error = "Page to edit not found" });
            }

            existingPage.Label = editPageRequest.Page.Label;
            existingPage.Icon = editPageRequest.Page.Icon;

            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Edit Page {ID} => {Label}", existingPage.ID, existingPage.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, existingPage, cancellationToken);

            return Ok(new AddPanelResponse());
        }

        [HttpPost("removepage")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemovePageResponse>> PostRemovePage([FromBody] RemovePageRequest removePanelRequest, CancellationToken cancellationToken)
        {
            // Include Panels to cascade delete 
            var pageToDelete = await _Context.Pages.Where(x => x.ID == removePanelRequest.PageId).Include(x => x.Groups).ThenInclude(g => g.Panels).FirstOrDefaultAsync(cancellationToken);
            if (pageToDelete == null)
            {
                return NotFound(new RemovePageResponse { Status = ResponseStatus.Error, Error = "Page to delete not found" });
            }

            _Context.Pages.Remove(pageToDelete);
            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Removed Page {Label}", pageToDelete.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemovePage, pageToDelete, cancellationToken);
            return Ok(new RemovePanelResponse());
        }


        /// <summary>
        /// POST: api/layout/addgroup
        /// </summary>
        [HttpPost("addgroup")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddGroupResponse>> PostAddGroup([FromBody] ApiModels.AddGroupRequest addGroupRequest, CancellationToken cancellationToken)
        {
            var newGroup = new Data.Group
            {
                SymbolicName = ConvertToSymbolicName(addGroupRequest.Group.Label),
                Label = addGroupRequest.Group.Label,
                PageID = addGroupRequest.Group.PageID,
            };
            _Context.Groups.Add(newGroup);

            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Added new Group {Label}", newGroup.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup, cancellationToken);
            return Ok(new AddGroupResponse());
        }

        /// <summary>
        /// POST: api/layout/editgroup
        /// </summary>
        [HttpPost("editgroup")]
        [LocalHost]
        public async Task<ActionResult<EditGroupResponse>> PostEditGroup([FromBody] EditGroupRequest editGroupRequest, CancellationToken cancellationToken)
        {
            var newGroup = await _Context.Groups.FindAsync(editGroupRequest.Group.Id, cancellationToken).ConfigureAwait(false);
            newGroup.Label = editGroupRequest.Group.Label;

            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Group {Label} edited", newGroup.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup, cancellationToken);
            return Ok(new EditGroupResponse());
        }

        [HttpPost("removegroup")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemoveGroupResponse>> PostRemoveGroup([FromBody] RemoveGroupRequest removeGroupRequest, CancellationToken cancellationToken)
        {
            // Include Panels to cascade delete 
            var groupToDelete = await _Context.Groups.Where(x => x.ID == removeGroupRequest.GroupId).Include(x => x.Panels).FirstOrDefaultAsync(cancellationToken);
            if (groupToDelete == null)
            {
                return NotFound(new RemoveGroupResponse { Status = ResponseStatus.Error, Error = "Group to delete not found" });
            }

            _Context.Groups.Remove(groupToDelete);
            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Removed Group {Label}", groupToDelete.Label);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemoveGroup, groupToDelete, cancellationToken);
            return Ok(new RemoveGroupResponse());
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("addpanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<AddPanelResponse>> PostAddPanel([FromBody] AddPanelRequest addPanelRequest, CancellationToken cancellationToken)
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

            await _Context.SaveChangesAsync(cancellationToken);

            _Logger.LogDebug("Added new Panel {SymbolicName}({PluginName})", newPanel.SymbolicName, newPanel.PluginName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, newPanel, cancellationToken);

            await _PluginContext.Subscribe(newPanel.ID, addPanelRequest.Panel.PluginName, addPanelRequest.Panel.SymbolicName, newPanel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value, StringComparer.Ordinal));

            return Ok(new AddPanelResponse());
        }

        /// <summary>
        /// POST: api/layout/addpage
        /// </summary>
        [HttpPost("editpanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<EditPanelResponse>> PostEditPanel([FromBody] EditPanelRequest editPanelRequest, CancellationToken cancellationToken)
        {
            // Include Panels to cascade delete 
            var existingPanel = await _Context.Panels.Where(x => x.ID == editPanelRequest.Panel.ID).Include(x => x.ConfigParameters).FirstOrDefaultAsync(cancellationToken);
            if (existingPanel == null)
            {
                return NotFound(new RemovePanelResponse { Status = ResponseStatus.Error, Error = "Panel to edit not found" });
            }

            existingPanel.SymbolicName = editPanelRequest.Panel.SymbolicName;
            existingPanel.GroupId = editPanelRequest.Panel.GroupId;
            foreach (var cp in existingPanel.ConfigParameters)
            {
                cp.Value = editPanelRequest.Panel.ConfigValues.FirstOrDefault(x => x.SymbolicName.Equals(cp.SymbolicName, StringComparison.Ordinal))?.Value?.ToString() ?? cp.Value;
            }

            await _Context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            _Logger.LogDebug("Edit Panel {ID} => {SymbolicName}({PluginName})", existingPanel.ID, existingPanel.SymbolicName, existingPanel.PluginName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, existingPanel, cancellationToken).ConfigureAwait(false);

            await _PluginContext.Subscribe(existingPanel.ID, existingPanel.PluginName, existingPanel.SymbolicName, existingPanel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value, StringComparer.Ordinal)).ConfigureAwait(false);

            return Ok(new AddPanelResponse());
        }

        [HttpPost("removepanel")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemovePanelResponse>> PostRemovePanel([FromBody] RemovePanelRequest removePanelRequest, CancellationToken cancellationToken)
        {
            // Include Panels to cascade delete 
            var panelToDelete = await _Context.Panels.Where(x => x.ID == removePanelRequest.PanelId).FirstOrDefaultAsync(cancellationToken).ConfigureAwait(false);
            if (panelToDelete == null)
            {
                return NotFound(new RemovePanelResponse { Status = ResponseStatus.Error, Error = "Panel to delete not found" });
            }

            _Context.Panels.Remove(panelToDelete);
            await _Context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            _Logger.LogDebug("Removed Panel {Label}", panelToDelete.SymbolicName);

            await _ClientHub.Clients.All.SendAsync(ClientMethods.RemovePanel, panelToDelete, cancellationToken).ConfigureAwait(false);
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
