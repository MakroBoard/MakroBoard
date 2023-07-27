namespace MakroBoard.PluginContract.Parameters
{
    public class BoolParameterValue : ParameterValue
    {
        public BoolParameterValue(BoolConfigParameter configParameter, bool value) : base(configParameter, value)
        {
            Value = value;
        }

        public bool Value { get; }
    }
}
