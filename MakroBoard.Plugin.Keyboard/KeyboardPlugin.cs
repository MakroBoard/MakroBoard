using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.Keyboard
{
    public class KeyboardPlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override string PluginIcon => "keyboard-settings-outline";

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new KeyboardControl(),
                new TextControl(),
            };
        }
    }
}
