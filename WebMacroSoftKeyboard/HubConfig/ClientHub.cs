using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Controllers;
using WebMacroSoftKeyboard.Data;

namespace WebMacroSoftKeyboard.HubConfig
{
    public class ClientHub : Hub
    {
        private readonly ClientContext _ClientContext;

        public ClientHub(ClientContext clientContext)
        {
            _ClientContext = clientContext;
        }

        public async override Task OnConnectedAsync()
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();
            await _ClientContext.Sessions.AddAsync(new Session { ClientIp = ip, ClientId = Context.ConnectionId });
            await _ClientContext.SaveChangesAsync();

            var clients = await _ClientContext.Clients.Where(x => x.State == ClientState.None && x.ValidUntil > DateTime.UtcNow || x.State == ClientState.Confirmed).ToListAsync();
            foreach (var client in clients)
            {
                await Clients./*Group("adminClients")*/All.SendAsync(ClientMethods.AddOrUpdateClient, client);
            }
            await base.OnConnectedAsync();
        }

        public async override Task OnDisconnectedAsync(Exception exception)
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();

            var sessionToRemove = await _ClientContext.Sessions.FirstOrDefaultAsync(x => x.ClientId == Context.ConnectionId);
            if (sessionToRemove != null)
            {
                _ClientContext.Sessions.Remove(sessionToRemove);
            }

            await base.OnDisconnectedAsync(exception);
        }
    }
}
