using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class Plugin
    {
        public Plugin(string pluginName, IEnumerable<Control> controls)
        {
            PluginName = pluginName;
            Controls = controls;
        }

        public string PluginName { get; }
        public IEnumerable<Control> Controls { get; }
    }
}
