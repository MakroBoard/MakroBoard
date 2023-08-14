using MakroBoard.PluginContract.Parameters;

namespace MakroBoard.PluginContract.Views
{
    public class ProgressBarView : View
    {
        public ProgressBarView(string label) : base(label)
        {
            Min = new IntConfigParameter("min", LocalizableString.Empty, 0);
            Max = new IntConfigParameter("max", LocalizableString.Empty, 100);
            Value = new IntConfigParameter("value", LocalizableString.Empty, 0);
            AddPluginParameter(Min);
            AddPluginParameter(Max);
            AddPluginParameter(Value);
        }


        public IntConfigParameter Min { get; }
        public IntConfigParameter Max { get; }
        public IntConfigParameter Value { get; }

        public override ViewType Type => ViewType.ProgressBar;
    }
}
