using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.Clock
{
    class ClockPlugin : MakroBoardPluginBase
    {
        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new ClockControl()
            };
        }
    }
}
