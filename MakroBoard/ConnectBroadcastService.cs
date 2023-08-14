using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Threading;
using System;
using System.Net.Sockets;
using System.Text;
using System.Net;
using Org.BouncyCastle.Utilities.Net;
using System.Linq;

namespace MakroBoard
{
    internal class ConnectBroadcastService : IHostedService, IDisposable
    {
        private const int _Port = 9876;
        private readonly ILogger<ConnectBroadcastService> _Logger;
        private Timer _Timer = null;
        private UdpClient _UdpClient = null;

        public ConnectBroadcastService(ILogger<ConnectBroadcastService> logger)
        {
            _Logger = logger;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _Logger.LogInformation("Timed Hosted Service running.");

            _UdpClient?.Dispose();
            _UdpClient = new UdpClient();
            _Timer = new Timer(DoWork, null, TimeSpan.Zero, TimeSpan.FromSeconds(5));

            return Task.CompletedTask;
        }

        private void DoWork(object state)
        {
            var hostName = Dns.GetHostName();
            
            // TODO get Port
            var data = Encoding.UTF8.GetBytes($@"makroboard:https:\\{hostName}:5001");
            _UdpClient.Send(data, data.Length, "255.255.255.255", _Port);

            var hostAdress = Dns.GetHostAddresses(string.Empty).Where(i => i.AddressFamily == AddressFamily.InterNetwork).FirstOrDefault();
            if(hostAdress  != null)
            {
                data = Encoding.UTF8.GetBytes($@"makroboard:https:\\{hostAdress}:5001");
                _UdpClient.Send(data, data.Length, "255.255.255.255", _Port);
            }
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _Logger.LogInformation("Timed Hosted Service is stopping.");
            _Timer?.Change(Timeout.Infinite, 0);
            return Task.CompletedTask;
        }

        public void Dispose()
        {
            _Timer?.Dispose();
            _UdpClient?.Dispose();
        }
    }
}
