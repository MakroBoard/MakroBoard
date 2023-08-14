using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.ShellExecute
{
    public class ShellExecutePlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override string PluginIcon => "console";

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new ShellExecuteControl(),
            };
        }
    }
}
