using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebMacroSoftKeyboard.HubConfig
{
    public class ClientHub : Hub
    {
        private Dictionary<string, string> _IPConnectionIds = new Dictionary<string, string>();

        public IReadOnlyDictionary<string, string> IPConnectionIds => _IPConnectionIds;

        public override Task OnConnectedAsync()
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();
            _IPConnectionIds.Add(ip, Context.ConnectionId);
            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception exception)
        {
            var ip = Context.GetHttpContext().Connection.RemoteIpAddress.ToString();
            _IPConnectionIds.Remove(ip);
            return base.OnDisconnectedAsync(exception);
        }
    }
}
