using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.Steam
{
    public class SteamPlugin : MakroBoardPluginBase
    {
        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
               new CsGoServerStatusControl(),
            };
        }
    }
}
