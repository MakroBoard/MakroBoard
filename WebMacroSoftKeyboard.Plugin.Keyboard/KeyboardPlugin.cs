using Desktop.Robot;
using Desktop.Robot.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.PluginContract;
using WebMacroSoftKeyboard.PluginContract.Parameters;
using WebMacroSoftKeyboard.PluginContract.Views;

namespace WebMacroSoftKeyboard.Plugin.Keyboard
{
    public class KeyboardPlugin : WebMacroSoftKeyboardPluginBase
    {
        public override async Task<IEnumerable<Control>> GetControls()
        {
            var controls = new List<Control>
            {
                new KeyboardControl()
            };

            var result = await Task.FromResult(controls).ConfigureAwait(false);
            return result;
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            return await Task.FromResult(new KeyboardControl()).ConfigureAwait(false);
        }
    }

    public class KeyboardControl : Control
    {
        private const string _ConfigChar = "char";
        public KeyboardControl() : base()
        {
            View = new ButtonView($"Press Key", ExecuteChar);
            AddConfigParameter(new StringConfigParameter(_ConfigChar, string.Empty, "[\x00-\x7F]"));
        }

        private string ExecuteChar(ConfigValues configValues)
        {
            if (configValues.TryGetConfigValue(_ConfigChar, out var configValue))
            {
                // TODO Better Convert
                new Robot().Type(configValue.Value.ToString());
                return $"Pressed {configValue.Value}";
            }

            return "Config value not found!";
        }

        public override View View { get; }

        public override string SymbolicName => $"Keyboard";
    }
}
