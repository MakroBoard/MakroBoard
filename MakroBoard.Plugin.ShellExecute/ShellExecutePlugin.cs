using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using NLog;
using MakroBoard.PluginContract;

namespace MakroBoard.Plugin.ShellExecute
{
    public class ShellExecutePlugin : MakroBoardPluginBase
    {
      private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        public async override Task<IEnumerable<Control>> GetControls()
        {
            var controls = new List<Control>
            {
                new ShellExecuteControl()
            };

            var result = await Task.FromResult(controls).ConfigureAwait(false);
            return result;
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            if (!symbolicName.Equals("ShellExecute"))
            {
                return null;
            }

            return await Task.FromResult(new ShellExecuteControl()).ConfigureAwait(false);
        }

    }
}
