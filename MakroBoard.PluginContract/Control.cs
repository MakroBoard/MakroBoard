using System.Collections.Generic;
using NLog;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Concurrent;

namespace MakroBoard.PluginContract
{
    public abstract class Control
    {
        private readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private readonly List<ConfigParameter> _ConfigParameters = new();
        private readonly IDictionary<int, Action<PanelChangedEventArgs>> _Subscriptions = new ConcurrentDictionary<int, Action<PanelChangedEventArgs>>();
        private ParameterValues _LastParameterValues;

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
            InternalSubscribe(configParameters, panelId, onControlChanged);
        }

        internal virtual void InternalSubscribe(ParameterValues configParameters, int panelId, Action<PanelChangedEventArgs> onControlChanged)
        {
            _Subscriptions.TryAdd(panelId, onControlChanged);
            _ = Task.Run(async () =>
            {
                // Delay Subscribe To be sure connection is established
                await Task.Delay(1000).ConfigureAwait(false);
                Subscribe(configParameters);
            });
        }

        protected virtual void Subscribe(ParameterValues configParameters)
        {

        }

        protected void OnControlChanged(ParameterValues parameterValues, bool force = false)
        {
            if (!force && _LastParameterValues != null && _LastParameterValues.Select(x => x.UntypedValue).SequenceEqual(parameterValues.Select(x => x.UntypedValue)))
            {
                return;
            }

            _LastParameterValues = parameterValues;

            foreach (var subscription in _Subscriptions)
            {
                try
                {
                    subscription.Value(new PanelChangedEventArgs(this, subscription.Key, parameterValues));
                }
                catch (Exception e)
                {
                    _Logger.Error(e, "Can not send PanelChanged for Subscription");
                }
            }
        }
    }
}
