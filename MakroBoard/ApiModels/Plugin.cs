using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class Plugin
    {
        public Plugin(string pluginName, LocalizableString title, Image icon, IEnumerable<Control> controls)
        {
            PluginName = pluginName;
            Title = title;
            Icon = icon;
            Controls = controls;
        }

        public string PluginName { get; }

        public LocalizableString Title { get; }

        public Image Icon { get; }

        public IEnumerable<Control> Controls { get; }
    }
}
