using MakroBoard.Plugin.Clock;
using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.MultiMedia
{
    public class MultiMediaPlugin : MakroBoardPluginBase
    {
        private List<Control>? _Controls;

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            _Controls ??= new List<Control>
                {
                    new SystemAudioControl(),
                };

            return _Controls;
        }
    }
}
