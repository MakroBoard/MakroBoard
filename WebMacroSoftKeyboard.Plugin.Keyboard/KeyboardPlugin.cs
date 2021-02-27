using Desktop.Robot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.PluginContract;

namespace WebMacroSoftKeyboard.Plugin.Keyboard
{
    public class KeyboardPlugin : WebMacroSoftKeyboardPluginBase
    {
        public override async Task<IEnumerable<Control>> GetControls()
        {
            var controls = new List<Control>();
            controls.Add(new KeyboardControl());
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
            ConfigParameters = new ConfigParameters
            {
                new StringConfigParameter(_ConfigChar, "[\x00-\x7F]")
            };
        }

        private string ExecuteChar(ConfigValues configValues)
        {
            if (configValues.TryGetConfigValue(_ConfigChar, out var configValue))
            {
                // TODO Better Convert
                new Robot().KeyPress(configValue.Value.ToString().Last());
                return $"Pressed {configValue.Value}";
            }

            return "Config value not found!";
        }

        public override View View { get; }

        public override string SymbolicName => $"Keyboard";

        public override ConfigParameters ConfigParameters { get; }
    }
}
