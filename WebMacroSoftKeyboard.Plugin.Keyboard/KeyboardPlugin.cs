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
            for (int i = char.MinValue; i <= char.MaxValue; i++)
            {
                char c = Convert.ToChar(i);
                if (!char.IsControl(c))
                {
                    controls.Add(new KeyboardControl(nameof(KeyboardPlugin), c));
                }
            }

            var result = await Task.FromResult(controls).ConfigureAwait(false);

            return result;
        }

        public async override Task<Control> GetControl(string symbolicName)
        {
            return await Task.FromResult(new KeyboardControl(nameof(KeyboardPlugin), symbolicName.Last())).ConfigureAwait(false);
        }
    }

    public class KeyboardControl : Control
    {
        private readonly char _Char;

        public KeyboardControl(string pluginName, char c) : base(pluginName, $"keyboard_{c}", $"Press {c}")
        {
            View = new ButtonView(ExecuteChar);
            _Char = c;
        }

        private string ExecuteChar()
        {
            new Robot().KeyPress(_Char);
            return $"Pressed {_Char}";
        }

        public override View View { get; }
    }
}
