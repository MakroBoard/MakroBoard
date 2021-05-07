using Desktop.Robot;
using Desktop.Robot.Extensions;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;

namespace MakroBoard.Plugin.Keyboard
{

    public class TextControl : Control
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
        private const string _ConfigChar = "char";
        public TextControl() : base()
        {
            View = new ButtonView($"Write Text", ExecuteText);
            AddConfigParameter(new StringConfigParameter(_ConfigChar, string.Empty));
        }

        private string ExecuteText(ParameterValues configValues)
        {
            if (configValues.TryGetConfigValue(_ConfigChar, out var configValue))
            {
                // TODO Better Convert
                new Robot().Type(configValue.UntypedValue.ToString());
                _logger.Debug($"Text written: {configValue.UntypedValue}");
                return "Text written";
            }

            _logger.Debug("Config value not found!");
            return "Config value not found!";
        }

        public override View View { get; }

        public override string SymbolicName => "Text";
    }
}