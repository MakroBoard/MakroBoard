﻿using System.Collections.Generic;
using WebMacroSoftKeyboard.PluginContract.Parameters;
using WebMacroSoftKeyboard.PluginContract.Views;

namespace WebMacroSoftKeyboard.PluginContract
{
    public abstract class Control
    {
        private IList<ConfigParameter> _ConfigParameters = new List<ConfigParameter>();
        protected Control()
        {
            ConfigParameters = new ConfigParameters(_ConfigParameters);
        }

        /// <summary>
        /// SymbolicName to identify the control
        /// </summary>
        public abstract string SymbolicName { get; }

        public abstract View View { get; }

        /// <summary>
        /// Config Parameters that are used for execution
        /// </summary>
        public ConfigParameters ConfigParameters { get; }

        protected void AddConfigParameter(ConfigParameter configParameter)
        {
            _ConfigParameters.Add(configParameter);
        }
    }
}
