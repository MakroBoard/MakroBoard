namespace MakroBoard.PluginContract.Parameters
{
    public class StringConfigParameter : ConfigParameter
    {
        public StringConfigParameter(string symbolicName, LocalizableString label, string defaultValue) : base(symbolicName, label)
        {
            DefaultValue = defaultValue;
        }

        public StringConfigParameter(string symbolicName, LocalizableString label, string defaultValue, string validationRegEx) : base(symbolicName, label)
        {
            DefaultValue = defaultValue;
            ValidationRegEx = validationRegEx;
        }

        public string DefaultValue { get; }

        public string ValidationRegEx { get; }
    }
}
