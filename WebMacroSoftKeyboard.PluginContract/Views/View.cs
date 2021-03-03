using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using WebMacroSoftKeyboard.PluginContract.Parameters;

namespace WebMacroSoftKeyboard.PluginContract.Views
{
    public abstract class View : PropertyChangedBase
    {
        private IList<ConfigParameter> _ConfigParameters = new List<ConfigParameter>();
        internal View(string label)
        {
            _ConfigParameters.Add(new StringConfigParameter("label", label, ".*"));
            ConfigParameters = new ConfigParameters(_ConfigParameters);
        }

        public abstract ViewType Type { get; }

        /// <summary>
        /// Config Parameters that are used for visualization
        /// </summary>
        public ConfigParameters ConfigParameters { get; }

        public virtual Bitmap BackgroundImage { get; }

        protected void AddConfigParameter(ConfigParameter configParameter)
        {
            _ConfigParameters.Add(configParameter);
        }
    }
}
