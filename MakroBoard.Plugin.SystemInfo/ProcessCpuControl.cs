using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Timers;
using Universe.CpuUsage;

namespace MakroBoard.Plugin.SystemInfo
{
    public class ProcessCpuControl : Control
    {
        private Timer _Timer;
        private CpuUsage? _LastUsage;
        private readonly ProgressBarView _ProgressBarView;
        private long _LastTicks = 0;
        
        public ProcessCpuControl()
        {
            _ProgressBarView = new ProgressBarView(SymbolicName);
        }

        public override string SymbolicName => nameof(ProcessCpuControl);

        public override View View => _ProgressBarView;

        protected override void Subscribe(ParameterValues configParameters)
        {
            _LastUsage = CpuUsage.GetByProcess();
            _LastTicks = DateTime.UtcNow.Ticks;


            var minValue = new IntParameterValue(_ProgressBarView.Min, 0);
            var maxValue = new IntParameterValue(_ProgressBarView.Max, 100);
            var value = new IntParameterValue(_ProgressBarView.Value, 0);
            OnControlChanged(new ParameterValues() { minValue, maxValue, value });

            if (_Timer == null)
            {
                _Timer = new Timer(1000);
                _Timer.Elapsed += (s, a) =>
                {
                    var usage = CpuUsage.GetByProcess();
                    var ticks = DateTime.UtcNow.Ticks;
                    var usageDiff = (usage - _LastUsage).Value.TotalMicroSeconds / 1000d;
                    var totalMicroSeconds = (ticks - _LastTicks) / 10000d;
                    var usagePercent = usageDiff / totalMicroSeconds * 100;
                    OnControlChanged(new ParameterValues() { new IntParameterValue(_ProgressBarView.Value, Math.Min(100, (int)usagePercent)) });
                    _LastUsage = usage;
                    _LastTicks = ticks;
                };

                _Timer.Start();
            }
        }
    }
}
