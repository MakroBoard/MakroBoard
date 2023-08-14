namespace MakroBoard.ApiModels
{
    public class ConfigParameter
    {
        private ConfigParameter(string symbolicName, LocalizableString label)
        {
            SymbolicName = symbolicName;
            Label = label;
        }

        public ConfigParameter(string symbolicName, LocalizableString label, string defaultValue, string validationRegEx) : this(symbolicName, label)
        {
            ParameterType = "string";
            ValidationRegEx = validationRegEx;
            DefaultValue = defaultValue;
        }

        public ConfigParameter(string symbolicName, LocalizableString label, int minValue, int maxValue) : this(symbolicName, label)
        {
            ParameterType = "int";
            MinValue = minValue;
            MaxValue = maxValue;
        }

        public ConfigParameter(string symbolicName, LocalizableString label, bool defaultValue) : this(symbolicName, label)
        {
            ParameterType = "bool";
            DefaultValue = defaultValue;
        }

        public string SymbolicName { get; }
        public LocalizableString Label { get; }
        public string ParameterType { get; }
        public object DefaultValue { get; }
        public string ValidationRegEx { get; }
        public int MinValue { get; }
        public int MaxValue { get; }
    }
}
