using System;
using System.Diagnostics.CodeAnalysis;

namespace WebMacroSoftKeyboard.PluginContract.Views
{
    public sealed class SlideView : View
    {
        private Func<double, string> _Execute;

        public SlideView(double min, double max, [NotNull] Func<double, string> execute) : base(string.Empty)
        {
            Min = min;
            Max = max;
            _Execute = execute;
        }

        public override ViewType Type => ViewType.Slider;

        public double Min { get; }
        public double Max { get; }

        public string Execute(double value)
        {
            return _Execute?.Invoke(value) ?? "No Action defined";
        }
    }
}
