using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public class MakroBoardPluginBase : IMakroBoardPlugin
    {
        protected MakroBoardPluginBase()
        {

        }

        public string SymbolicName => GetType().Name;

        public virtual async Task<Control> GetControl(string symbolicName)
        {
            var controls = await GetControls();
            var control = controls.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, System.StringComparison.OrdinalIgnoreCase));

            return await Task.FromResult(control).ConfigureAwait(false);
        }

        public virtual async Task<IEnumerable<Control>> GetControls()
        {
            return await Task.FromResult(Enumerable.Empty<Control>());
        }
    }
}
