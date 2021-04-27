namespace MakroBoard.PluginContract.Parameters
{
    public class BoolConfigParameter : ConfigParameter
    {
        public BoolConfigParameter(string symbolicName, bool defaultValue) : base(symbolicName)
        {
            DefaultValue = defaultValue;
        }

        public bool DefaultValue { get; }
    }

    public class BoolParameterValue : ParameterValue
    {
        public BoolParameterValue(BoolConfigParameter configParameter, bool value) : base(configParameter, value)
        {
            Value = value;
        }

        public bool Value { get; }
    }
}
