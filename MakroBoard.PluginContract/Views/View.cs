using System.Collections.Generic;
using System.Drawing;
using MakroBoard.PluginContract.Parameters;

namespace MakroBoard.PluginContract.Views
{
    public abstract class View : PropertyChangedBase
    {
        private readonly List<ConfigParameter> _ConfigParameters = new();
        private readonly List<ConfigParameter> _PluginParameters = new();

        protected View(string label)
        {
            _ConfigParameters.Add(new StringConfigParameter("label", label, ".*"));
            ConfigParameters = new ConfigParameters(_ConfigParameters);
            PluginParameters = new ConfigParameters(_PluginParameters);
        }

        public abstract ViewType Type { get; }

        /// <summary>
        /// Config Parameters that are used for visualization
        /// </summary>
        public ConfigParameters ConfigParameters { get; }

        /// <summary>
        /// Config Parameters that are set by the Plugin
        /// </summary>
        public ConfigParameters PluginParameters { get; }

        public virtual Bitmap BackgroundImage { get; }

        protected void AddConfigParameter(ConfigParameter configParameter)
        {
            _ConfigParameters.Add(configParameter);
        }

        protected void AddPluginParameter(ConfigParameter pluginParameter)
        {
            _PluginParameters.Add(pluginParameter);
        }
    }
}
