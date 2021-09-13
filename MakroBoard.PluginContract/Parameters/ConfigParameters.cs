using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;

namespace MakroBoard.PluginContract.Parameters
{
    public class ConfigParameters : ReadOnlyCollection<ConfigParameter>
    {
        public ConfigParameters(IList<ConfigParameter> list) : base(list)
        {
        }

        public ConfigParameter this[string symbolicName]
        {
            get => this.First(x => x.SymbolicName.Equals(symbolicName, System.StringComparison.OrdinalIgnoreCase));
            set => throw new ReadOnlyException();
        }
    }
}
