namespace MakroBoard.PluginContract.Parameters
{
    public class ConfigParameter
    {
        protected ConfigParameter(string symbolicName, LocalizableString label)
        {
            SymbolicName = symbolicName;
            Label = label;
        }

        public string SymbolicName { get; }

        public LocalizableString Label { get; }
    }
}
