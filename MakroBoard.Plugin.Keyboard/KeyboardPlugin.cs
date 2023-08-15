using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.Keyboard
{
    public class KeyboardPlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("keyboard-settings-outline", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new KeyControl(),
                new TextControl(),
            };
        }
    }
}
