using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class View
    {
        public View(string viewType, ConfigParameters configParameters, ConfigParameters pluginParameters, IList<View> subViews)
        {
            ViewType = viewType;
            ConfigParameters = configParameters;
            PluginParameters = pluginParameters;
            SubViews = subViews;
        }

        public string ViewType { get; }

        public string Value { get; }

        public ConfigParameters ConfigParameters { get; }
        public ConfigParameters PluginParameters { get; }

        public IList<View> SubViews { get; }
    }
}
