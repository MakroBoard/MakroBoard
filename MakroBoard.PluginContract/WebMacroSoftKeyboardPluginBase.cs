using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NLog;

namespace MakroBoard.PluginContract
{
    public class MakroBoardPluginBase : IMakroBoardPlugin
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        protected MakroBoardPluginBase()
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
