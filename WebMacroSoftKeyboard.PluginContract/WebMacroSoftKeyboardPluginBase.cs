using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NLog;

namespace WebMacroSoftKeyboard.PluginContract
{
    public class WebMacroSoftKeyboardPluginBase : IWebMacroSoftKeyboardPlugin
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        protected WebMacroSoftKeyboardPluginBase()
        {
         
        }

        public virtual async Task<Control> GetControl(string symbolicName)
        {
            return await Task.FromResult<Control>(null);
        }

        public virtual async Task<IEnumerable<Control>> GetControls()
        {
            return await Task.FromResult(Enumerable.Empty<Control>());
        }
    }
}
