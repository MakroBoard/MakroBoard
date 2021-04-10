using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;

namespace MakroBoard.Controllers.ApiModels
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

    public class Control
    {
        public Control(string symbolicName, View view, ConfigParameters configParameters)
        {
            SymbolicName = symbolicName;
            View = view;
            ConfigParameters = configParameters;
        }

        public string SymbolicName { get; }

        public View View { get; }
        public ConfigParameters ConfigParameters { get; }
    }

    public class View
    {
        public View(string viewType, ConfigParameters configParameters)
        {
            ViewType = viewType;
            ConfigParameters = configParameters;
        }

        public string ViewType { get; }

        public string Value { get; }

        public ConfigParameters ConfigParameters { get; }
    }

    public class ConfigParameter
    {
        private ConfigParameter(string symbolicName)
        {
            SymbolicName = symbolicName;
        }

        public ConfigParameter(string symbolicName, string defaultValue, string validationRegEx) : this(symbolicName)
        {
            ParameterType = "string";
            ValidationRegEx = validationRegEx;
            DefaultValue = defaultValue;
        }

        public ConfigParameter(string symbolicName, int minValue, int maxValue) : this(symbolicName)
        {
            ParameterType = "int";
            MinValue = minValue;
            MaxValue = maxValue;
        }

        public ConfigParameter(string symbolicName, bool defaultValue) : this(symbolicName)
        {
            ParameterType = "bool";
            DefaultValue = defaultValue;
        }

        public string SymbolicName { get; }
        public string ParameterType { get; }
        public object DefaultValue { get; }
        public string ValidationRegEx { get; }
        public int MinValue { get; }
        public int MaxValue { get; }
    }

    public class ConfigParameters : Collection<ConfigParameter>
    {

        public ConfigParameters()
        {

        }

        public ConfigParameters(IList<ConfigParameter> configParameters) : base(configParameters)
        {

        }
    }

    public class ConfigValue
    {
        public ConfigValue(string symbolicName, object value)
        {
            SymbolicName = symbolicName;
            Value = value;
        }

        public string SymbolicName { get;  }

        public object Value { get;  }
    }

    public class ConfigValues : Collection<ConfigValue>
    {

    }
}
