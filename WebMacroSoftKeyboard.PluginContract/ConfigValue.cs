namespace WebMacroSoftKeyboard.PluginContract
{
    public class ConfigValue
    {
        public ConfigValue(string symbolicName, object value)
        {
            SymbolicName = symbolicName;
            Value = value;
        }

        public string SymbolicName { get; }

        public object Value { get; }
    }
}
