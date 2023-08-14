namespace MakroBoard.PluginContract.Parameters
{
    public class BoolConfigParameter : ConfigParameter
    {
        public BoolConfigParameter(string symbolicName, LocalizableString label, bool defaultValue) : base(symbolicName, label)
        {
            DefaultValue = defaultValue;
        }

        public bool DefaultValue { get; }
    }
}
