using MakroBoard.PluginContract.Parameters;

namespace MakroBoard.PluginContract.Views
{
    public class ProgressBarView : View
    {
        public ProgressBarView(string label) : base(label)
        {
            Min = new IntConfigParameter("min", 0);
            Max = new IntConfigParameter("max", 100);
            Value = new IntConfigParameter("value", 0);
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
