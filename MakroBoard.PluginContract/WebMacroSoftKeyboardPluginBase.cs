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
            return await Task.FromResult<Control>(null);
        }

        public virtual async Task<IEnumerable<Control>> GetControls()
        {
            return await Task.FromResult(Enumerable.Empty<Control>());
        }
    }
}
