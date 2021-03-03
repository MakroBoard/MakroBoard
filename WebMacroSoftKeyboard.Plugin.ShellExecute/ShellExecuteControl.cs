using System;
using System.Diagnostics;
using WebMacroSoftKeyboard.PluginContract;
using WebMacroSoftKeyboard.PluginContract.Parameters;
using WebMacroSoftKeyboard.PluginContract.Views;

namespace WebMacroSoftKeyboard.Plugin.ShellExecute
{
    internal class ShellExecuteControl : Control
    {
        private const string _ConfigCommand = "command";

        public ShellExecuteControl() : base()
        {
            View = new ButtonView($"Execute", ExecuteCommand);
            AddConfigParameter(new StringConfigParameter(_ConfigCommand, string.Empty, ".*"));
            //AddConfigParameter(new BoolConfigParameter(_ConfigCommand, false));
        }

        private string ExecuteCommand(ConfigValues arg)
        {
            if (!arg.TryGetConfigValue(_ConfigCommand, out var command) || command?.Value == null || string.IsNullOrEmpty(command.Value.ToString()))
            {
                return "No Command defined!";
            }

            try
            {
                var process = Process.Start(command.Value.ToString());
                //process.WaitForExitAsync()
            }
            catch(Exception e)
            {
                return "Could not execute command";
            }

            return "Successfully Started!";
        }

        public override string SymbolicName => "ShellExecute";

        public override View View { get; }

    }
}