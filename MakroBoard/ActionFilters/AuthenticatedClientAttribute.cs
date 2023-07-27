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
    public class AuthenticatedClientAttribute : ActionFilterAttribute
    {
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;
        private readonly ClientState _MinClientState;

        public AuthenticatedClientAttribute(DatabaseContext context, IHubContext<ClientHub> clientHub) : this(context, clientHub, ClientState.Confirmed)
        {
        }

        protected AuthenticatedClientAttribute(DatabaseContext context, IHubContext<ClientHub> clientHub, ClientState minClientState)
        {
            _Context = context;
            _ClientHub = clientHub;
            _MinClientState = minClientState;
        }

        public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
        {
            var cancellationToken = context.HttpContext.RequestAborted;
            if (context.HttpContext.Request.Headers.TryGetValue("authorization", out var token))
            {
                var clientIp = context.HttpContext.Connection.RemoteIpAddress;
                var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp.ToString()), cancellationToken);

                if (client != null)
                {
                    if (client.State >= _MinClientState && client.Token.Equals(token, System.StringComparison.Ordinal))
                    {
                        await base.OnActionExecutionAsync(context, next);
                        return;
                    }

                    client.State = ClientState.None;
                    client.Token = null;
                    await _Context.SaveChangesAsync(cancellationToken);
                    await _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, client, cancellationToken);
                }
            }

            context.Result = new UnauthorizedResult();
        }
    }
}
