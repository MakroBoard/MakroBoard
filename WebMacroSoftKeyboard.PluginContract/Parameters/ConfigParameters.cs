using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace WebMacroSoftKeyboard.PluginContract.Parameters
{
    public class ConfigParameters : ReadOnlyCollection<ConfigParameter>
    {
        public ConfigParameters(IList<ConfigParameter> list) : base(list)
        {
        }
    }
}
