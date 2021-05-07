using NLog;
using System.Collections.Generic;
using System.Threading.Tasks;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.Keyboard
{
    public class KeyboardPlugin : MakroBoardPluginBase
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        public override async Task<IEnumerable<Control>> GetControls()
        {
            var controls = new List<Control>
            {
                new KeyboardControl(),
                new TextControl()
            };

            var result = await Task.FromResult(controls).ConfigureAwait(false);
            return result;
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            Control control;
            switch (symbolicName)
            {
                case "Keyboard":
                    control = new KeyboardControl();
                    break;
                case "Text":
                    control = new TextControl();
                    break;
                default:
                    return null;
            }

            return await Task.FromResult(control).ConfigureAwait(false);
        }
    }


}
