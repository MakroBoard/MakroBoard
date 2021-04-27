namespace MakroBoard.PluginContract.Parameters
{
    public class StringParameterValue : ParameterValue
    {
        public StringParameterValue(StringConfigParameter configParameter, string value) : base(configParameter, value)
        {
            Value = value;
        }

        public string Value { get; }
    }
}
