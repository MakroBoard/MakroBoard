using System.Collections.Generic;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.ShellExecute
{
    public class ShellExecutePlugin : MakroBoardPluginBase
    {
        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new ShellExecuteControl(),
            };
        }
    }
}
