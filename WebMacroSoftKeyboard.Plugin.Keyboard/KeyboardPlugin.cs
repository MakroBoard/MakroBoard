using NLog;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.PluginContract;

namespace WebMacroSoftKeyboard.Plugin.Keyboard
{
    public class KeyboardPlugin : WebMacroSoftKeyboardPluginBase
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        public override async Task<IEnumerable<Control>> GetControls()
        {
            var controls = new List<Control>
            {
                new KeyboardControl()
            };

            var result = await Task.FromResult(controls).ConfigureAwait(false);
            return result;
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            if(!symbolicName.Equals("Keyboard"))
            {
                return null;
            }

            return await Task.FromResult(new KeyboardControl()).ConfigureAwait(false);
        }
    }

   
}
