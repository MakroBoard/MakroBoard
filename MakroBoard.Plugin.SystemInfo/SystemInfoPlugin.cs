using MakroBoard.PluginContract;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.Plugin.SystemInfo
{
    class SystemInfoPlugin : MakroBoardPluginBase
    {
        private IEnumerable<Control> _Controls;
        public override async Task<IEnumerable<Control>> GetControls()
        {
            if (_Controls == null)
            {
                var memoryControl = new MemoryControl();
                var cpuControl = new ProcessCpuControl();
                _Controls = new List<Control>
                {
                    memoryControl,
                    cpuControl,
                    new ListControl("SystemInfo", new Control[]{memoryControl, cpuControl} )
                };
            }

            return await Task.FromResult(_Controls).ConfigureAwait(false);
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            var controls = await GetControls();
            var control = controls.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, System.StringComparison.OrdinalIgnoreCase));

            return await Task.FromResult(control).ConfigureAwait(false);
        }
    }
}
