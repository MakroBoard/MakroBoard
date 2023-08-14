using Desktop.Robot;
using Desktop.Robot.Extensions;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System.Collections.ObjectModel;
using System;
using System.Collections.Generic;
using System.Linq;

namespace MakroBoard.Plugin.Keyboard
{

    public class KeyControl : Control
    {
        private readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private const string _ConfigModifier = "modifier";
        private const string _ConfigChar = "char";
        private readonly Robot _Robot;
        private readonly Collection<EnumConfigParameter.EnumItem> _Modifiers = new()
        {
            new EnumConfigParameter.EnumItem("none", new LocalizableString(Resource.ResourceManager, nameof(Resource.KeyNone))),
            new EnumConfigParameter.EnumItem("ctrl", new LocalizableString(Resource.ResourceManager, nameof(Resource.KeyControl))),
        };

        public KeyControl() : base()
        {
            _Robot = new Robot();
            View = new ButtonView($"Press Key", ExecuteChar);
            AddConfigParameter(new EnumConfigParameter(_ConfigModifier, new LocalizableString(Resource.ResourceManager, nameof(Resource.Modifier)), _Modifiers, "none"));
            AddConfigParameter(new StringConfigParameter(_ConfigChar, new LocalizableString(Resource.ResourceManager, nameof(Resource.Character)), string.Empty, "[\x00-\x7F]"));
        }

        private string ExecuteChar(ParameterValues configValues)
        {
            var keys = new List<Key>();
            if (configValues.TryGetConfigValue<StringParameterValue>(_ConfigModifier, out var modifierId))
            {
                switch (modifierId.Value)
                {
                    case "none":
                        break;
                    case "ctrl":
                        keys.Add(Key.Control);
                        break;
                    default:
                        throw new NotSupportedException($"The modifier {modifierId.Value} is not supported!");

                }
            }


            if (configValues.TryGetConfigValue<StringParameterValue>(_ConfigChar, out var configValue) && Enum.TryParse<Key>(configValue.Value, true, out var key))
            {
                keys.Add(key);
            }

            if (keys.Count > 0)
            {
                _Robot.CombineKeys(keys.ToArray());
                var resultMessage = $"Pressed {string.Join(", ", keys)}";
                _Logger.Debug(resultMessage);
                return resultMessage;
            }

            _Logger.Debug("Config value not found!");
            return "Config value not found!";
        }


        public override View View { get; }

        public override string SymbolicName => "Keyboard";
    }
}