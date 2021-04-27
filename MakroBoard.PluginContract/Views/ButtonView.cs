using MakroBoard.PluginContract.Parameters;
using System;

namespace MakroBoard.PluginContract.Views
{
    public sealed class ButtonView : View
    {
        private readonly Func<ParameterValues, string> _Execute;

        public ButtonView(string label, Func<ParameterValues, string> execute) : base(label)
        {

            _Execute = execute;
        }

        public override ViewType Type => ViewType.Button;

        public string Execute(ParameterValues parameterValues)
        {
            return _Execute?.Invoke(parameterValues) ?? "No Action defined";
        }
    }
}
