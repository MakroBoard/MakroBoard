using System.Collections.Generic;

namespace MakroBoard.PluginContract.Views
{
    public class ListView : View
    {
        public ListView(string label, IReadOnlyList<View> subViews) : base(label)
        {
            SubViews = subViews;
        }

        public IReadOnlyList<View> SubViews { get; }

        public override ViewType Type => ViewType.List;
    }
}
