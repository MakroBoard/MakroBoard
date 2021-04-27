using System;
using System.Collections.ObjectModel;
using System.Linq;

namespace MakroBoard.PluginContract.Parameters
{
    public class ParameterValues : Collection<ParameterValue>
    {
        public bool TryGetConfigValue(string symbolicName, out ParameterValue parameterValue)
        {
            parameterValue = this.FirstOrDefault(x => x.ConfigParameter.SymbolicName.Equals(symbolicName, StringComparison.Ordinal));
            return parameterValue != null;
        }
    }
}
