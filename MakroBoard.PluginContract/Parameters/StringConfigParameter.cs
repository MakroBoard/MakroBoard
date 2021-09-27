﻿namespace MakroBoard.PluginContract.Parameters
{
    public class StringConfigParameter : ConfigParameter
    {
        public StringConfigParameter(string symbolicName, string defaultValue) : base(symbolicName)
        {
            DefaultValue = defaultValue;
        }

        public StringConfigParameter(string symbolicName, string defaultValue, string validationRegEx) : base(symbolicName)
        {
            DefaultValue = defaultValue;
            ValidationRegEx = validationRegEx;
        }

        public string DefaultValue { get; }

        public string ValidationRegEx { get; }
    }

    public class ListConfigParameter : ConfigParameter
    {
        public ListConfigParameter(string symbolicName) : base(symbolicName)
        {
        }
    }
}
