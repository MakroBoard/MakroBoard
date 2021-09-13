namespace MakroBoard.PluginContract.Parameters
{
    public class IntConfigParameter : ConfigParameter
    {
        public IntConfigParameter(string symbolicName, int defaultValue) : this(symbolicName, int.MinValue, int.MaxValue, defaultValue)
        {
        }


        public IntConfigParameter(string symbolicName, int minValue, int maxValue) : this(symbolicName, minValue, maxValue, 0)
        {
        }

        public IntConfigParameter(string symbolicName, int minValue, int maxValue, int defaultValue) : base(symbolicName)
        {
            MinValue = minValue;
            MaxValue = maxValue;
            DefaultValue = defaultValue;
        }

        public int MinValue { get; }
        public int MaxValue { get; }
        public int DefaultValue { get; }
    }
}
