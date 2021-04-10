using System;

namespace MakroBoard.PluginContract.Views
{
    public sealed class ButtonView : View
    {
        private readonly Func<ConfigValues, string> _Execute;
        private string _Label;

        public ButtonView(string label, Func<ConfigValues, string> execute) : base(label)
        {
            _Execute = execute;
        }

        public override ViewType Type => ViewType.Button;

        public string Execute(ConfigValues configValues)
        {
            return _Execute?.Invoke(configValues) ?? "No Action defined";
        }
    }
}
