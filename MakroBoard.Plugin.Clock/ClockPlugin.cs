﻿using MakroBoard.PluginContract;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.Plugin.Clock
{
    class ClockPlugin : MakroBoardPluginBase
    {
        private IEnumerable<Control> _Controls;
        public override async Task<IEnumerable<Control>> GetControls()
        {
            if (_Controls == null)
            {
                _Controls = new List<Control>
                {
                    new ClockControl()
                };
            }

            return await Task.FromResult(_Controls).ConfigureAwait(false);
        }
    }
}
