using MakroBoard.PluginContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MakroBoard.Plugin.Steam
{
    public class SteamPlugin : MakroBoardPluginBase
    {
        private IEnumerable<Control> _Controls;

        public override async Task<IEnumerable<Control>> GetControls()
        {
            if (_Controls == null)
            {
                _Controls = new List<Control>
                {
                    new CsGoServerStatusControl()
                };
            }

            return await Task.FromResult(_Controls).ConfigureAwait(false);
        }
    }
}
