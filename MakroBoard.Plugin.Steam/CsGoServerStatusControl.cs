using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using NLog;
using SteamWebAPI2.Interfaces;
using SteamWebAPI2.Utilities;
using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Timers;

namespace MakroBoard.Plugin.Steam
{
    public class CsGoServerStatusControl : Control, IDisposable
    {
        private readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private readonly TextView _TextView;
        private Timer _Timer;
        private readonly SteamWebInterfaceFactory _Factory;

        public CsGoServerStatusControl()
        {
            _TextView = new TextView("CS GO Server Status");
            _Factory = new SteamWebInterfaceFactory("<TODO API Token here>");
        }

        public override string SymbolicName => "CS GO Server Status";

        public override View View => _TextView;

        protected override void Subscribe(ParameterValues configParameters)
        {
            if (_Timer == null)
            {
                _Timer = new Timer(10000);
                _Timer.Elapsed += OnTimerTick;
                OnTimerTick(null, null);
            }
        }

        private void OnTimerTick(object s, ElapsedEventArgs a)
        {
            _Timer.Stop();
            Task.Run(async () =>
            {
                try
                {
                    var webInterface = _Factory.CreateSteamWebInterface<CSGOServers>();
                    var status = await webInterface.GetGameServerStatusAsync();

                    OnControlChanged(new ParameterValues() { new StringParameterValue(_TextView.TextParameter, $"CSGO Servers: {status.Data.Matchmaking.OnlineServers}\nCSGO Players: {status.Data.Matchmaking.OnlinePlayers}\nCSGO Players Searching: {status.Data.Matchmaking.SearchingPlayers}") });
                }
                catch(HttpRequestException requestException) when (requestException.StatusCode == HttpStatusCode.Forbidden)
                {
                    _Logger.Error("Getting Steam Status forbidden.");
                    OnControlChanged(new ParameterValues() { new StringParameterValue(_TextView.TextParameter, $"Wrong or no Steam API Key configured!") });
                }
                catch (Exception ex)
                {
                    _Logger.Error(ex, "Error getting Steam Status");
                }
                finally
                {
                    _Timer.Start();
                }
            });

        }

        public void Dispose()
        {
            throw new NotImplementedException();
        }
    }
}
