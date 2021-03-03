namespace WebMacroSoftKeyboard.PluginContract.Parameters
{
    public class BoolConfigParameter : ConfigParameter
    {
        public BoolConfigParameter(string symbolicName, bool defaultValue) : base(symbolicName)
        {
            DefaultValue = defaultValue;
        }

        public bool DefaultValue { get; }
    }
}
