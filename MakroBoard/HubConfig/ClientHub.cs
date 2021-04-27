using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Net;
using System.Threading.Tasks;
using MakroBoard.Controllers;
using MakroBoard.Data;
using MakroBoard.Plugin;
using System.Linq;
using MakroBoard.PluginContract.Parameters;
using System.Collections.Generic;
using MakroBoard.PluginContract;
using MakroBoard.Controllers.ApiModels;

namespace MakroBoard.HubConfig
{
    public class ClientHub : Hub
    {
        private readonly DatabaseContext _DatabaseContext;
        private readonly PluginContext _PluginContext;
        IHubContext<ClientHub> _hubContext = null;

        public ClientHub(DatabaseContext databaseContext, PluginContext pluginContext, IHubContext<ClientHub> hubContext)
        {
            _DatabaseContext = databaseContext;
            _PluginContext = pluginContext;
            _hubContext = hubContext;

            SubscribePanels().Wait();
        }

        private bool IsLocalHost(IPAddress ipAddress)
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

                var control = await plugin.GetControl(panel.SymbolicName);
                if (control == null)
                {
                    // Skip Panels where control is no more available
                    continue;
                }

                control.Subscribe(CreateParameterValues(control, panel.ConfigParameters), panel.ID, OnControlChanged);
            }
        }

        private ParameterValues CreateParameterValues(PluginContract.Control control, IList<Data.ConfigParameterValue> configParameters)
        {
            var parameterValues = new ParameterValues();

            foreach (var configParameter in configParameters)
            {
                var controlConfigParameter = control.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.SymbolicName, StringComparison.OrdinalIgnoreCase)) ?? control.View.ConfigParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.SymbolicName, StringComparison.OrdinalIgnoreCase)) ?? control.View.PluginParameters.FirstOrDefault(x => x.SymbolicName.Equals(configParameter.SymbolicName, StringComparison.OrdinalIgnoreCase));
                switch (controlConfigParameter)
                {
                    case IntConfigParameter icp:
                        parameterValues.Add(new IntParameterValue(icp, int.Parse(configParameter.Value)));
                        break;
                    case StringConfigParameter scp:
                        parameterValues.Add(new StringParameterValue(scp, configParameter.Value));
                        break;
                    case BoolConfigParameter bcp:
                        parameterValues.Add(new BoolParameterValue(bcp, configParameter.Value != null ? bool.Parse(configParameter.Value) : bcp.DefaultValue));
                        break;
                    default:
                        throw new NotImplementedException($"{controlConfigParameter.GetType().Name} is not yet implemented!");
                }
            }

            foreach(var pluginParameter in control.View.PluginParameters)
            {
                switch (pluginParameter)
                {
                    case IntConfigParameter icp:
                        parameterValues.Add(new IntParameterValue(icp, 0));
                        break;
                    case StringConfigParameter scp:
                        parameterValues.Add(new StringParameterValue(scp, scp.DefaultValue));
                        break;
                    case BoolConfigParameter bcp:
                        parameterValues.Add(new BoolParameterValue(bcp, bcp.DefaultValue));
                        break;
                    default:
                        throw new NotImplementedException($"{pluginParameter.GetType().Name} is not yet implemented!");
                }
            }

            return parameterValues;
        }

        private void OnControlChanged(PanelChangedEventArgs panelChangedEventArgs)
        {
            //panelChangedEventArgs.
            _ = _hubContext.Clients.All.SendAsync(ClientMethods.UpdatePanelData, new PanelData(panelChangedEventArgs.PanelId, panelChangedEventArgs.ParameterValues.Select(x => new ConfigValue(x.ConfigParameter.SymbolicName, x.UntypedValue)).ToList()));
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
                existingClient = new Data.Client { ClientIp = ipAddress.ToString(), RegisterDate = DateTime.UtcNow };
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

            var pages = await _DatabaseContext.Pages.Include(p => p.Groups).ThenInclude((g) => g.Panels).ThenInclude(p => p.ConfigParameters).ToListAsync();
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

        //private void OnPanelDataChanged(PanelsChangedEventArgs)
    }
}
