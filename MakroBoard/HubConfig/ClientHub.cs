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

        private static bool IsLocalHost(IPAddress ipAddress)
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

                var control = await plugin.GetControl(panel.SymbolicName).ConfigureAwait(false);
                if (control == null)
                {
                    // Skip Panels where control is no more available
                    continue;
                }

                //_PluginContext.Subscribe(panel.ID, control, CreateParameterValues(control, panel.ConfigParameters));
                _ = _PluginContext.Subscribe(panel.ID, panel.PluginName, panel.SymbolicName, panel.ConfigParameters.ToDictionary(x => x.SymbolicName, x => x.Value, StringComparer.Ordinal));
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

            var cancellationToken = ctx.RequestAborted;
            var isLocalHost = IsLocalHost(ipAddress);

            var existingClient = await _DatabaseContext.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(ipAddress.ToString()), cancellationToken).ConfigureAwait(false);

            if (existingClient == null)
            {
                existingClient = new Client { ClientIp = ipAddress.ToString(), RegisterDate = DateTime.UtcNow, State = isLocalHost ? ClientState.Admin : ClientState.None };
                if (isLocalHost)
                {
                    existingClient.CreateNewToken(Constants.Seed);
                }
            }

            existingClient.LastConnection = DateTime.UtcNow;

            await _DatabaseContext.Sessions.AddAsync(new Session { ClientSignalrId = Context.ConnectionId, Client = existingClient }, cancellationToken).ConfigureAwait(false);
            await _DatabaseContext.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            if (isLocalHost)
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup, cancellationToken).ConfigureAwait(false);

                var clients = await _DatabaseContext.Clients.ToListAsync(cancellationToken).ConfigureAwait(false);//.Where(x => x.State == ClientState.None && x.ValidUntil > DateTime.UtcNow || x.State == ClientState.Confirmed).ToListAsync();
                foreach (var client in clients)
                {
                    await Clients.Caller.SendAsync(ClientMethods.AddOrUpdateClient, client, cancellationToken).ConfigureAwait(false);
                }
            }
            else
            {
                // Any sync needed?
            }

            var pages = await _DatabaseContext.Pages.Include(p => p.Groups).ThenInclude((g) => g.Panels).ThenInclude(p => p.ConfigParameters).ToListAsync(cancellationToken).ConfigureAwait(false);
            foreach (var page in pages)
            {
                await Clients.Caller.SendAsync(ClientMethods.AddOrUpdatePage, page, cancellationToken).ConfigureAwait(false);
            }

            await SubscribePanels().ConfigureAwait(false);
            if (isLocalHost)
            {
                await Clients.Caller.SendAsync(ClientMethods.AddOrUpdateToken, existingClient.Token, cancellationToken).ConfigureAwait(false);
            }

            await Clients.Caller.SendAsync(ClientMethods.Initialized, cancellationToken).ConfigureAwait(false);

            await base.OnConnectedAsync().ConfigureAwait(false);
        }

        public async override Task OnDisconnectedAsync(Exception exception)
        {
            var cancellationToken = Context.ConnectionAborted;
            var sessionToRemove = await _DatabaseContext.Sessions.FirstOrDefaultAsync(x => x.ClientSignalrId == Context.ConnectionId, cancellationToken).ConfigureAwait(false);
            if (sessionToRemove != null)
            {
                _DatabaseContext.Sessions.Remove(sessionToRemove);
            }

            await Groups.RemoveFromGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup, cancellationToken).ConfigureAwait(false);

            await base.OnDisconnectedAsync(exception).ConfigureAwait(false);
        }
    }
}
