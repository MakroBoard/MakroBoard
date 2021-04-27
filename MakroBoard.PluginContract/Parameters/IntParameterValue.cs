namespace MakroBoard.PluginContract.Parameters
{
    public class IntParameterValue : ParameterValue
    {
        public IntParameterValue(IntConfigParameter configParameter, int value) : base(configParameter, value)
        {
            Value = value;
        }

        public int Value { get; }
    }
}
