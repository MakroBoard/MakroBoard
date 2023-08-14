using Desktop.Robot;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;

namespace MakroBoard.Plugin.Keyboard
{
    public class TextControl : Control
    {
        private readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private const string _ConfigChar = "char";
        public TextControl() : base()
        {
            _Robot = new Robot();

            View = new ButtonView($"Write Text", ExecuteText);
            AddConfigParameter(new StringConfigParameter(_ConfigChar,new LocalizableString(Resource.ResourceManager, nameof(Resource.Text)), string.Empty));
        }

        private string ExecuteText(ParameterValues configValues)
        {
            if (configValues.TryGetConfigValue(_ConfigChar, out var configValue))
            {
                var text = configValue.UntypedValue.ToString();
                foreach(var character in text)
                { 
                    if(char.IsUpper(character))
                    {
                        _Robot.KeyDown(Key.Shift);
                        _Robot.KeyPress(character);
                        _Robot.KeyUp(Key.Shift);
                    }
                    else
                    {
                        _Robot.KeyPress(character);
                    }
                }
                _Logger.Debug($"Text written: {text}");
                return "Text written";
            }

            _Logger.Debug("Config value not found!");
            return "Config value not found!";
        }

        private readonly Robot _Robot;

        public override View View { get; }

        public override string SymbolicName => "Text";
    }
}