using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.Steam
{
    public class SteamPlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("steam", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
               new CsGoServerStatusControl(),
            };
        }
    }
}
