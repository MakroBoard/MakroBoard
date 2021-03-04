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
        private const string _ConfigWaitForExit = "Wait for Exit";

        public ShellExecuteControl() : base()
        {
            View = new ButtonView($"Execute", ExecuteCommand);
            AddConfigParameter(new StringConfigParameter(_ConfigExecutable, string.Empty, ".*"));
            AddConfigParameter(new StringConfigParameter(_ConfigArguments, string.Empty, ".*"));
            AddConfigParameter(new BoolConfigParameter(_ConfigWaitForExit, false));
            //AddConfigParameter(new BoolConfigParameter(_ConfigCommand, false));
        }

        private string ExecuteCommand(ConfigValues arg)
        {
            if (!arg.TryGetConfigValue(_ConfigExecutable, out var command) || command?.Value == null || string.IsNullOrEmpty(command.Value.ToString()))
            {
                return "No Command defined!";
            }

            if (!arg.TryGetConfigValue(_ConfigArguments, out var arguments))
            {
                return "No Command defined!";
            }

            bool waitForExit = false;
            if (arg.TryGetConfigValue(_ConfigWaitForExit, out var waitForExitParameter) && waitForExitParameter?.Value is bool b)
            {
                waitForExit = b;
            }

            try
            {
                var process = Process.Start(new ProcessStartInfo(command.Value.ToString(), arguments.Value?.ToString())
                {
                    UseShellExecute = true
                });
                if (waitForExit)
                {
                    process.WaitForExit();
                    return $"Successfully exited. ExitCode: {process.ExitCode}";
                }
            }
            catch (Exception e)
            {
                return "Could not execute command";
            }

            return "Successfully Started!";
        }

        public override string SymbolicName => "ShellExecute";

        public override View View { get; }

    }
}