using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.ShellExecute
{
    public class ShellExecutePlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("console", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new ShellExecuteControl(),
            };
        }
    }
}
