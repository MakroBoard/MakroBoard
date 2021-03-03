using System.Collections.Generic;
using System.Threading.Tasks;

namespace WebMacroSoftKeyboard.PluginContract
{
    public interface IWebMacroSoftKeyboardPlugin
    {
        Task<IEnumerable<Control>> GetControls();

        Task<Control> GetControl(string symbolicName);
    }
}
