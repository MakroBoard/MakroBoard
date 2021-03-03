namespace WebMacroSoftKeyboard.PluginContract.Parameters
{
    public class IntConfigParameter : ConfigParameter
    {
        public IntConfigParameter(string symbolicName, int minValue, int maxValue) : base(symbolicName)
        {
            MinValue = minValue;
            MaxValue = maxValue;
        }

        public int MinValue { get; }
        public int MaxValue { get; }
    }
}
