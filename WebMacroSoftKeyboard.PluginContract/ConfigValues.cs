using System;
using System.Collections.ObjectModel;
using System.Linq;

namespace WebMacroSoftKeyboard.PluginContract
{
    public class ConfigValues : Collection<ConfigValue>
    {
        public bool TryGetConfigValue(string symbolicName, out ConfigValue configValue)
        {
            configValue = this.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, StringComparison.Ordinal));
            return configValue != null;
        }
    }
}
