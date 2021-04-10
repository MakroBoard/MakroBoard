using Desktop.Robot;
using Desktop.Robot.Extensions;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;

namespace MakroBoard.Plugin.Keyboard
{

 public class KeyboardControl : Control
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
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
                _logger.Debug($"Pressed {configValue.Value}");
                return $"Pressed {configValue.Value}";
            }
  _logger.Debug("Config value not found!");
            return "Config value not found!";
        }

        public override View View { get; }

        public override string SymbolicName => "Keyboard";
    }
    }