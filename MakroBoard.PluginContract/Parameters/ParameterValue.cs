namespace MakroBoard.PluginContract.Parameters
{
    public class ParameterValue
    {
        protected ParameterValue(ConfigParameter configParameter, object untypedValue)
        {
            ConfigParameter = configParameter;
            UntypedValue = untypedValue;
        }

        public ConfigParameter ConfigParameter { get; }

        public object UntypedValue { get; }
    }
}
