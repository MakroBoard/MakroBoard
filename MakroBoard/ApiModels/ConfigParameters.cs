using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MakroBoard.ApiModels
{
    public class ConfigParameters : Collection<ConfigParameter>
    {

        public ConfigParameters()
        {

        }

        public ConfigParameters(IList<ConfigParameter> configParameters) : base(configParameters)
        {

        }
    }
}
