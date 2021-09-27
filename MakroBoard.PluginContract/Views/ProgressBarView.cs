using MakroBoard.PluginContract.Parameters;
using System.Collections.Generic;

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

    public class ListView : View
    {
        public ListView(string label, IReadOnlyList<View> subViews) : base(label)
        {
            SubViews = subViews;
            //foreach (var subView in SubViews)
            //{
            //    foreach (var configParameter in subView.ConfigParameters)
            //    {
            //        AddConfigParameter(configParameter);
            //    }

            //    foreach (var pluginParameter in subView.PluginParameters)
            //    {
            //        AddPluginParameter(pluginParameter);
            //    }
            //}
        }

        public IReadOnlyList<View> SubViews { get; }

        public override ViewType Type => ViewType.List;
    }
}
