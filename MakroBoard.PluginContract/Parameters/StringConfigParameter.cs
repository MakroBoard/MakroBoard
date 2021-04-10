namespace MakroBoard.PluginContract.Parameters
{
    public class StringConfigParameter : ConfigParameter
    {
        public StringConfigParameter(string symbolicName, string defaultValue, string validationRegEx) : base(symbolicName)
        {
            DefaultValue = defaultValue;
            ValidationRegEx = validationRegEx;
        }

        public string DefaultValue { get; }

        public string ValidationRegEx { get; }
    }
}
