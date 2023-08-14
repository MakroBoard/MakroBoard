namespace MakroBoard.PluginContract.Parameters
{
    public class IntConfigParameter : ConfigParameter
    {
        public IntConfigParameter(string symbolicName, LocalizableString label, int defaultValue) : this(symbolicName, label, int.MinValue, int.MaxValue, defaultValue)
        {
        }


        public IntConfigParameter(string symbolicName, LocalizableString label, int minValue, int maxValue) : this(symbolicName, label, minValue, maxValue, 0)
        {
        }

        public IntConfigParameter(string symbolicName, LocalizableString label, int minValue, int maxValue, int defaultValue) : base(symbolicName, label)
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
