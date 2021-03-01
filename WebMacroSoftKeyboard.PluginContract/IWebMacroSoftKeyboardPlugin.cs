using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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

    public abstract class View : PropertyChangedBase
    {
        internal View()
        {
            ConfigParameters = new ConfigParameters { new StringConfigParameter("label", ".*") };
        }

        public abstract string Type { get; }

        public virtual string Label { get; }

        public ConfigParameters ConfigParameters { get; }

        public virtual Bitmap BackgroundImage { get; }
    }

    public sealed class ImageView : View
    {
        public override string Type => "Image";
    }

    public sealed class ButtonView : View
    {
        private readonly Func<ConfigValues, string> _Execute;
        private string _Label;


        public ButtonView(Func<ConfigValues, string> execute)
        {
            _Execute = execute;
        }

        public ButtonView(string label, Func<ConfigValues, string> execute) : this(execute)
        {
            _Label = label;
        }

        public override string Type => "Button";

        public override string Label => _Label;

        public string Execute(ConfigValues configValues)
        {
            return _Execute?.Invoke(configValues) ?? "No Action defined";
        }
    }

    public sealed class SlideView : View
    {
        private Func<double, string> _Execute;

        public SlideView(double min, double max, [NotNull] Func<double, string> execute)
        {
            Min = min;
            Max = max;
            _Execute = execute;
        }

        public override string Type => "Slider";

        public double Min { get; }
        public double Max { get; }

        public string Execute(double value)
        {
            return _Execute?.Invoke(value) ?? "No Action defined";
        }
    }

    public class ConfigParameter
    {
        protected ConfigParameter(string symbolicName)
        {
            SymbolicName = symbolicName;
        }

        public string SymbolicName { get; }
    }

    public class StringConfigParameter : ConfigParameter
    {
        public StringConfigParameter(string symbolicName, string validationRegEx) : base(symbolicName)
        {
            ValidationRegEx = validationRegEx;
        }

        public string ValidationRegEx { get; }
    }

    public class IntConfigParameter : ConfigParameter
    {
        public IntConfigParameter(string symbolicName, int minValue, int maxValue) : base(symbolicName)
        {
            MinValue = minValue;
            MaxValue = maxValue;
        }

        public int MinValue { get; }
        public int MaxValue { get; }
    }

    public class ConfigParameters : Collection<ConfigParameter>
    {

    }

    public class ConfigValue
    {
        public ConfigValue(string symbolicName, object value)
        {
            SymbolicName = symbolicName;
            Value = value;
        }

        public string SymbolicName { get; }

        public object Value { get; }
    }

    public class ConfigValues : Collection<ConfigValue>
    {
        public bool TryGetConfigValue(string symbolicName, out ConfigValue configValue)
        {
            configValue = this.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, StringComparison.Ordinal));
            return configValue != null;
        }
    }



    public abstract class Control
    {
        protected Control()
        {
        }

        /// <summary>
        /// SymbolicName to identify the control
        /// </summary>
        public abstract string SymbolicName { get; }

        public abstract View View { get; }

        public abstract ConfigParameters ConfigParameters { get; }
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
