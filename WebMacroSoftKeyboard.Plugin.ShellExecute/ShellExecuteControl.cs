using System;
using System.Diagnostics;
using WebMacroSoftKeyboard.PluginContract;
using WebMacroSoftKeyboard.PluginContract.Parameters;
using WebMacroSoftKeyboard.PluginContract.Views;

namespace WebMacroSoftKeyboard.Plugin.ShellExecute
{
    internal class ShellExecuteControl : Control
    {
        private const string _ConfigExecutable = "executable";
        private const string _ConfigArguments = "arguments";

        public ShellExecuteControl() : base()
        {
            View = new ButtonView($"Execute", ExecuteCommand);
            AddConfigParameter(new StringConfigParameter(_ConfigExecutable, string.Empty, ".*"));
            AddConfigParameter(new StringConfigParameter(_ConfigArguments, string.Empty, ".*"));
            //AddConfigParameter(new BoolConfigParameter(_ConfigCommand, false));
        }

        private string ExecuteCommand(ConfigValues arg)
        {
            if (!arg.TryGetConfigValue(_ConfigExecutable, out var command) || command?.Value == null || string.IsNullOrEmpty(command.Value.ToString()))
            {
                return "No Command defined!";
            }
            arg.TryGetConfigValue(_ConfigArguments, out var arguments);

            try
            {
                var process = Process.Start(new ProcessStartInfo(command.Value.ToString(),arguments.Value.ToString())
                {
                    UseShellExecute = true
                });
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return "Could not execute command";
            }

            return "Successfully Started!";
        }

        public override string SymbolicName => "ShellExecute";

        public override View View { get; }

    }
}