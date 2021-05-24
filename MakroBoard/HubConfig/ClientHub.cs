using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Net;
using System.Threading.Tasks;
using MakroBoard.Controllers;
using MakroBoard.Data;
using MakroBoard.Plugin;
using System.Linq;

namespace MakroBoard.HubConfig
{
    public class ClientHub : Hub
    {
        private readonly DatabaseContext _DatabaseContext;
        private readonly PluginContext _PluginContext;

        public ClientHub(DatabaseContext databaseContext, PluginContext pluginContext)
        {
            _DatabaseContext = databaseContext;
            _PluginContext = pluginContext;
        }

        private bool IsLocalHost(IPAddress ipAddress)
        {
            return IPAddress.IsLoopback(ipAddress);
        }

        private async Task SubscribePanels()
        {
            foreach (var panel in _DatabaseContext.Panels.Include(x => x.ConfigParameters))
            {
                var plugin = _PluginContext.Plugins.FirstOrDefault(x => x.SymbolicName.Equals(panel.PluginName, StringComparison.OrdinalIgnoreCase));
                if (plugin == null)
                {
                    // Skip Panels where plugin is no more available
                    continue;
                }

                var control = await plugin.GetControl(panel.SymbolicName);
                if (control == null)
                {
                    // Skip Panels where control is no more available
                    continue;
                }

                //_PluginContext.Subscribe(panel.ID, control, CreateParameterValues(control, panel.ConfigParameters));
                _ = _PluginContext.Subscribe(panel.ID, panel.PluginName, panel.SymbolicName, panel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value));
            }
        }

        public async override Task OnConnectedAsync()
        {
            var ctx = Context.GetHttpContext();
            var ipAddress = Context.GetHttpContext().Connection.RemoteIpAddress;
            if (ipAddress == null)
            {
                Context.Abort();
                return;
            }

            var isLocalHost = IsLocalHost(ipAddress);

            var existingClient = await _DatabaseContext.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(ipAddress.ToString()));

            var sendToken = false;
            if (existingClient == null)
            {
                existingClient = new Data.Client { ClientIp = ipAddress.ToString(), RegisterDate = DateTime.UtcNow, State = isLocalHost ? ClientState.Admin : ClientState.None };
                if (isLocalHost)
                {
                    existingClient.CreateNewToken(Constants.Seed);
                    sendToken = true;
                }
            }

            existingClient.LastConnection = DateTime.UtcNow;

            await _DatabaseContext.Sessions.AddAsync(new Session { ClientSignalrId = Context.ConnectionId, Client = existingClient });
            await _DatabaseContext.SaveChangesAsync();

            if (isLocalHost)
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup);

                var clients = await _DatabaseContext.Clients.ToListAsync();//.Where(x => x.State == ClientState.None && x.ValidUntil > DateTime.UtcNow || x.State == ClientState.Confirmed).ToListAsync();
                foreach (var client in clients)
                {
                    await Clients.Caller.SendAsync(ClientMethods.AddOrUpdateClient, client);
                }
            }
            else
            {
                // Any sync needed?
            }

            var pages = await _DatabaseContext.Pages.Include(p => p.Groups).ThenInclude((g) => g.Panels).ThenInclude(p => p.ConfigParameters).ToListAsync();
            foreach (var page in pages)
            {
                await Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, page);
            }

            await SubscribePanels();
            if(sendToken)
            {
                await Clients.Caller.SendAsync(ClientMethods.AddOrUpdateToken, existingClient.Token);
            }

            await Clients.Caller.SendAsync(ClientMethods.Initialized);

            await base.OnConnectedAsync();
        }

        public async override Task OnDisconnectedAsync(Exception exception)
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();

            var sessionToRemove = await _DatabaseContext.Sessions.FirstOrDefaultAsync(x => x.ClientSignalrId == Context.ConnectionId);
            if (sessionToRemove != null)
            {
                var test = _DatabaseContext.Sessions.Remove(sessionToRemove);
            }

            await Groups.RemoveFromGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup);

            await base.OnDisconnectedAsync(exception);
        }
    }
}
