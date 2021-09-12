using System.Linq;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using MakroBoard.Data;
using Microsoft.AspNetCore.SignalR;
using MakroBoard.HubConfig;
using MakroBoard.Controllers;
using System.Threading.Tasks;

namespace MakroBoard.ActionFilters
{
    public class AuthenticatedClient : ActionFilterAttribute
    {
        private DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;
        private readonly ClientState _MinClientState;

        public AuthenticatedClient(DatabaseContext context, IHubContext<ClientHub> clientHub) : this(context, clientHub, ClientState.Confirmed)
        {
        }

        protected AuthenticatedClient(DatabaseContext context, IHubContext<ClientHub> clientHub, ClientState minClientState)
        {
            _Context = context;
            _ClientHub = clientHub;
            _MinClientState = minClientState;
        }

        public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            if (context.HttpContext.Request.Headers.TryGetValue("authorization", out var token) || IsLocalHost(context.HttpContext.Connection.RemoteIpAddress))
            {
                var clientIp = context.HttpContext.Connection.RemoteIpAddress;
                var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp.ToString()));

                if (client != null)
                {
                    if (client.State >= _MinClientState && client.Token.Equals(token, System.StringComparison.Ordinal))
                    {
                        await base.OnActionExecutionAsync(context, next);
                        return;
                    }
                    else
                    {
                        client.State = ClientState.None;
                        client.Token = null;
                        await _Context.SaveChangesAsync();
                        await _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, client);
                    }
                }
            }else
            {

            }


            context.Result = new UnauthorizedResult();

        }

        private bool IsLocalHost(IPAddress ipAddress)
        {
            return IPAddress.IsLoopback(ipAddress);
        }
    }

    public class AuthenticatedAdmin : AuthenticatedClient
    {
        public AuthenticatedAdmin(DatabaseContext context, IHubContext<ClientHub> clientHub) : base(context, clientHub, ClientState.Admin)
        {
        }
    }
}
