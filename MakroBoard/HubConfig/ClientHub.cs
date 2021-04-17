using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using MakroBoard.Controllers;
using MakroBoard.Data;

namespace MakroBoard.HubConfig
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
            var ctx = Context.GetHttpContext();
            var ipAddress = Context.GetHttpContext().Connection.RemoteIpAddress;
            if (ipAddress == null)
            {
                Context.Abort();
                return;
            }

            var existingClient = await _DatabaseContext.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(ipAddress.ToString()));

            if (existingClient == null)
            {
                existingClient = new Client { ClientIp = ipAddress.ToString(), RegisterDate = DateTime.UtcNow };
            }
            existingClient.LastConnection = DateTime.UtcNow;

            await _DatabaseContext.Sessions.AddAsync(new Session { ClientSignalrId = Context.ConnectionId, Client = existingClient });
            await _DatabaseContext.SaveChangesAsync();



            if (IsLocalHost(ipAddress))
            {
                await Groups.AddToGroupAsync(Context.ConnectionId, ClientGroups.AdminGroup);

                var clients = await _DatabaseContext.Clients.ToListAsync();//.Where(x => x.State == ClientState.None && x.ValidUntil > DateTime.UtcNow || x.State == ClientState.Confirmed).ToListAsync();
                foreach (var client in clients)
                {
                    _ = Clients.Caller.SendAsync(ClientMethods.AddOrUpdateClient, client);
                }
            }
            else
            {
                // Any sync needed?
            }

            if (existingClient.State == ClientState.Confirmed)
            {
                Clients.Caller.SendAsync(ClientMethods.AddOrUpdateToken, existingClient.Token);
            }

            var pages = await _DatabaseContext.Pages.Include(p=>p.Groups).ToListAsync();
            foreach (var page in pages)
            {
                _ = Clients.All.SendAsync(ClientMethods.AddOrUpdatePage, page);
            }

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
