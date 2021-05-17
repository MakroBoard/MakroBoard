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
using Org.BouncyCastle.Math.EC.Rfc7748;
using Microsoft.EntityFrameworkCore;
using MakroBoard.ApiModels;

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
        public async Task<ActionResult<ApiModels.AddPageResponse>> PostAddPAge([FromBody] ApiModels.AddPageRequest addPageRequest)
        {
            var newPage = new Data.Page
            {
                SymbolicName = ConvertToSymbolicName(addPageRequest.Page.Label),
                Label = addPageRequest.Page.Label,
                Icon = addPageRequest.Page.Icon,
                Groups = new List<Data.Group>()
            };
            _Context.Pages.Add(newPage);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Page {newPage.Label}");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, newPage);
            return Ok(new AddPageResponse());
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
                PageID = addGroupRequest.Group.PageID
            };
            _Context.Groups.Add(newGroup);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Group {newGroup.Label}");

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
            var newGroup =_Context.Groups.Find(editGroupRequest.Group.Id);
            newGroup.Label = editGroupRequest.Group.Label;

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Group {newGroup.Label} edited");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdateGroup, newGroup);
            return Ok(new EditGroupResponse());
        }

        [HttpPost("removegroup")]
        [ServiceFilter(typeof(AuthenticatedAdmin))]
        public async Task<ActionResult<RemoveGroupResponse>> PostRemoveGroup([FromBody] RemoveGroupRequest removeGroupRequest)
        {
            // Include Panels to cascade delete 
            var groupToDelete = await _Context.Groups.Where(x=>x.ID == removeGroupRequest.GroupId).Include(x=>x.Panels).FirstAsync();
            if (groupToDelete == null)
            {
                return Conflict(new RemoveGroupResponse { Status = ResponseStatus.Error, Error = "Group to delete not found" });
            }

            _Context.Groups.Remove(groupToDelete);
            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Removed Group {groupToDelete.Label}");

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
                GroupID = addPanelRequest.Panel.GroupId
            };

            newPanel.ConfigParameters = addPanelRequest.Panel.ConfigValues.Select(x => new Data.ConfigParameterValue
            {
                SymbolicName = x.SymbolicName,
                Value = x.Value?.ToString(),
                Panel = newPanel,
            }).ToList();

            _Context.Panels.Add(newPanel);

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Added new Panel {newPanel.SymbolicName}({newPanel.PluginName})");

            await _ClientHub.Clients.All.SendAsync(ClientMethods.AddOrUpdatePanel, newPanel);

            await _PluginContext.Subscribe(newPanel.ID, addPanelRequest.Panel.PluginName, addPanelRequest.Panel.SymbolicName, newPanel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value));

            return Ok(new AddPanelResponse());
        }

        private static string ConvertToSymbolicName(string name)
        {
            return Regex.Replace(name, @"\s+", "-").ToLower();
        }
    }
}
