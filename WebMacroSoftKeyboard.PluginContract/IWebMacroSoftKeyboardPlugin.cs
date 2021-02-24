using Prise.Plugin;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebMacroSoftKeyboard.PluginContract
{
    public class View
    {

    }

    public sealed class ButtonView : View
    {

    }

    public abstract class Control
    {
        protected Control(string label)
        {
            Label = label;
        }

        public string Label { get; }

        public abstract View View { get; }
    }

    public abstract class Action : Control
    {
        protected Action(string label) : base(label)
        {
        }

        public abstract string Execute(string data);
    }


    public interface IWebMacroSoftKeyboardPlugin
    {
        Task<IEnumerable<Control>> GetControls();
    }

    public class WebMacroSoftKeyboardPluginBase : IWebMacroSoftKeyboardPlugin
    {
        public virtual Task<IEnumerable<Control>> GetControls()
        {
            return Task.FromResult(Enumerable.Empty<Control>());
        }
    }
}
