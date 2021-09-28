using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Timers;

namespace MakroBoard.Plugin.Clock
{
    public class SystemAudioControl : Control
    {
        private readonly SliderView _SliderView;
        private Timer _Timer;

        public SystemAudioControl()
        {
            _SliderView = new SliderView(0, 100, UpdateAudio);
        }

        public override string SymbolicName => "Clock";

        public override View View => _SliderView;

        private string UpdateAudio(double value)
        {
            return string.Empty;
        }

        protected override void Subscribe(ParameterValues configParameters)
        {
            if (_Timer == null)
            {
                _Timer = new Timer(1000);
                _Timer.Elapsed += (s, a) => OnControlChanged(new ParameterValues() { new IntParameterValue(_SliderView.ValueParameter, 0) });
                _Timer.Start();
            }
        }
    }
}
