using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public abstract class MakroBoardPluginBase : IMakroBoardPlugin
    {
        protected MakroBoardPluginBase()
        {
            Controls = InitializeControls();
        }

        protected abstract IReadOnlyCollection<Control> InitializeControls();

        public string SymbolicName => GetType().Name;

        public IReadOnlyCollection<Control> Controls { get; }

        public virtual async Task<Control> GetControl(string symbolicName)
        {
            var controls = await GetControls().ConfigureAwait(false);
            var control = controls.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, System.StringComparison.OrdinalIgnoreCase));

            return control;
        }

        public virtual Task<IEnumerable<Control>> GetControls()
        {
            return Task.FromResult<IEnumerable<Control>>(Controls);
        }
    }
}
