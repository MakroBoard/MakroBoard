using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class AvailableControlsResponse : Response
    {
        public AvailableControlsResponse(List<Plugin> plugins)
        {
            Plugins = plugins;
        }

        public IList<Plugin> Plugins { get; }
    }
}
