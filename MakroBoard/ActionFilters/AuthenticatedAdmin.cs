using MakroBoard.Data;
using Microsoft.AspNetCore.SignalR;
using MakroBoard.HubConfig;

namespace MakroBoard.ActionFilters
{
    public class AuthenticatedAdmin : AuthenticatedClientAttribute
    {
        public AuthenticatedAdmin(DatabaseContext context, IHubContext<ClientHub> clientHub) : base(context, clientHub, ClientState.Admin)
        {
        }
    }
}
