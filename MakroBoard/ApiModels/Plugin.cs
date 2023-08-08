using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class Plugin
    {
        public Plugin(string pluginName, LocalizableString title, IEnumerable<Control> controls)
        {
            PluginName = pluginName;
            Title = title;
            Controls = controls;
        }

        public string PluginName { get; }

        public LocalizableString Title { get; }

        public IEnumerable<Control> Controls { get; }
    }
}
