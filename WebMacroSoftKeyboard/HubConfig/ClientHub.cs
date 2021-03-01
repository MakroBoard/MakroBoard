using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Controllers;
using WebMacroSoftKeyboard.Data;

namespace WebMacroSoftKeyboard.HubConfig
{
    public class ClientHub : Hub
    {
        private readonly DatabaseContext _DatabaseContext;

        private bool IsLocalHost(IPAddress ipAddress)
        {
            return IPAddress.IsLoopback(ipAddress);
        }

        public ClientHub(DatabaseContext databaseContext)
        {
            _DatabaseContext = databaseContext;
        }

        public async override Task OnConnectedAsync()
        {
            var ipAddress = Context.GetHttpContext().Connection.RemoteIpAddress;
            if (ipAddress == null)
            {
                Context.Abort();
                return;
            }

           
            var existingClient = await _DatabaseContext.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(ipAddress.ToString()));

            if (existingClient == null)
            {
                existingClient = new Client {ClientIp = ipAddress.ToString(),RegisterDate = DateTime.UtcNow };
            }
            existingClient.LastConnection = DateTime.UtcNow;

            await _DatabaseContext.Sessions.AddAsync(new Session { ClientSignalrId = Context.ConnectionId, Client = existingClient });
            await _DatabaseContext.SaveChangesAsync();

            var clients = await _DatabaseContext.Clients.Where(x => x.State == ClientState.None && x.ValidUntil > DateTime.UtcNow || x.State == ClientState.Confirmed).ToListAsync();
            foreach (var client in clients)
            {
                await Clients.Caller.SendAsync(ClientMethods.AddOrUpdateClient, client);
            }

            if (IsLocalHost(ipAddress))
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup);
            }

            await base.OnConnectedAsync();
        }

        public async override Task OnDisconnectedAsync(Exception exception)
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();

            var sessionToRemove = await _DatabaseContext.Sessions.FirstOrDefaultAsync(x => x.ClientSignalrId == Context.ConnectionId);
            if (sessionToRemove != null)
            {
              var test =  _DatabaseContext.Sessions.Remove(sessionToRemove);
            }

            await Groups.RemoveFromGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup);

            await base.OnDisconnectedAsync(exception);
        }
    }
}
