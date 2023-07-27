using System.Collections.Generic;

namespace MakroBoard.PluginContract.Views
{
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
