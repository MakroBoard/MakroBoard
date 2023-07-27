namespace MakroBoard.ApiModels
{
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
}
