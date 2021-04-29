using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Timers;

namespace MakroBoard.Plugin.SystemInfo
{
    public class MemoryControl : Control
    {
        private Timer _Timer;
        private ProgressBarView _ProgressBarView;
        private MemoryMetricsClient _MemoryMetricClient;
        public MemoryControl()
        {
            _ProgressBarView = new ProgressBarView("MemoryUsage");
            _MemoryMetricClient = new MemoryMetricsClient();
        }

        public override string SymbolicName => "MemoryUsage";

        public override View View => _ProgressBarView;

        protected override void Subscribe(ParameterValues configParameters)
        {
            var initialMetrics = _MemoryMetricClient.GetMetrics();
            var minValue = new IntParameterValue(_ProgressBarView.Min, 0);
            var maxValue = new IntParameterValue(_ProgressBarView.Max, (int)initialMetrics.Total);
            var value = new IntParameterValue(_ProgressBarView.Value, (int)initialMetrics.Used);
            OnControlChanged(new ParameterValues() { minValue, maxValue, value });

            if (_Timer == null)
            {
                _Timer = new Timer(1000);
                _Timer.Elapsed += (s, a) =>
                {
                    var metrics = _MemoryMetricClient.GetMetrics();
                    OnControlChanged(new ParameterValues() { new IntParameterValue(_ProgressBarView.Value, (int)metrics.Used) });
                };

                _Timer.Start();
            }
        }
    }
}
