using System.Collections.Generic;
using NLog;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public abstract class Control
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        private IList<ConfigParameter> _ConfigParameters = new List<ConfigParameter>();
        private List<Tuple<int, Action<PanelChangedEventArgs>>> _Subscriptions = new List<Tuple<int, Action<PanelChangedEventArgs>>>();

        protected Control()
        {

            ConfigParameters = new ConfigParameters(_ConfigParameters);
        }

        /// <summary>
        /// SymbolicName to identify the control
        /// </summary>
        public abstract string SymbolicName { get; }

        public abstract View View { get; }


        /// <summary>
        /// Config Parameters that are used for execution
        /// </summary>
        public ConfigParameters ConfigParameters { get; }

        protected void AddConfigParameter(ConfigParameter configParameter)
        {
            _ConfigParameters.Add(configParameter);
        }

        public void Subscribe(ParameterValues configParameters, int panelId, Action<PanelChangedEventArgs> onControlChanged)
        {
            _Subscriptions.Add(new Tuple<int, Action<PanelChangedEventArgs>>(panelId, onControlChanged));
            Task.Run(async () =>
            {
                // Delay Subscribe To be sure connection is established
                await Task.Delay(1000);
                Subscribe(configParameters);
            });
        }

        protected virtual void Subscribe(ParameterValues configParameters)
        {

        }

        protected void OnControlChanged(ParameterValues parameterValues)
        {
            foreach (var subscription in _Subscriptions)
            {
                try
                {
                    subscription.Item2(new PanelChangedEventArgs(this, subscription.Item1, parameterValues));
                }
                catch (Exception e)
                {
                    _logger.Error(e, "Can not send PanelChanged for Subscription");
                }
            }
        }
    }
}
