using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.Keyboard
{
    public class KeyboardPlugin : MakroBoardPluginBase
    {
        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new KeyboardControl(),
                new TextControl()
            };
        }
    }
}
