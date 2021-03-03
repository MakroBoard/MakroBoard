namespace WebMacroSoftKeyboard.PluginContract.Parameters
{
    public class ConfigParameter
    {
        protected ConfigParameter(string symbolicName)
        {
            SymbolicName = symbolicName;
        }

        public string SymbolicName { get; }
    }
}
