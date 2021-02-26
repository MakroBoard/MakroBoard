using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics.CodeAnalysis;
using System.Drawing;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace WebMacroSoftKeyboard.PluginContract
{
    public class PropertyChangedBase : INotifyPropertyChanged
    {
        protected PropertyChangedBase()
        {

        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }

    public class View : PropertyChangedBase
    {
        internal View()
        {
        }

        public virtual string Label { get; }

        public virtual Bitmap BackgroundImage { get; }
    }

    public sealed class ImageView : View
    {

    }

    public sealed class ButtonView : View
    {
        private readonly Func<string> _Execute;

        public ButtonView([NotNull] Func<string> execute)
        {
            _Execute = execute;
        }

        public string Execute()
        {
            return _Execute?.Invoke() ?? "No Action defined";
        }
    }

    public abstract class Control
    {
        protected Control(string symbolicName)
        {
            SymbolicName = symbolicName;
        }

        /// <summary>
        /// SymbolicName to identify the control
        /// </summary>
        public string SymbolicName { get; }

        public abstract View View { get; }
    }

    public interface IWebMacroSoftKeyboardPlugin
    {
        Task<IEnumerable<Control>> GetControls();

        Task<Control> GetControl(string symbolicName);
    }

    public class WebMacroSoftKeyboardPluginBase : IWebMacroSoftKeyboardPlugin
    {
        protected WebMacroSoftKeyboardPluginBase()
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
