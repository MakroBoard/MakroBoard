using MakroBoard.PluginContract.Parameters;
using System;
using System.Diagnostics.CodeAnalysis;

namespace MakroBoard.PluginContract.Views
{
    public sealed class SliderView : View
    {
        private readonly Func<double, string> _Execute;

        public SliderView(double min, double max, [NotNull] Func<double, string> execute) : base(string.Empty)
        {
            Min = min;
            Max = max;
            _Execute = execute;

            ValueParameter = new IntConfigParameter("value", LocalizableString.Empty, 0);
            AddPluginParameter(ValueParameter);
        }

        public IntConfigParameter ValueParameter { get; }
        
        public override ViewType Type => ViewType.Slider;

        public double Min { get; }
        public double Max { get; }

        public string Execute(double value)
        {
            return _Execute?.Invoke(value) ?? "No Action defined";
        }
    }
}
