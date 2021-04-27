using System;
using System.Diagnostics;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;

namespace MakroBoard.Plugin.ShellExecute
{
    internal class ShellExecuteControl : Control
    {
        private readonly ILogger _logger = LogManager.GetCurrentClassLogger();
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

        private string ExecuteCommand(ParameterValues arg)
        {
            if (!arg.TryGetConfigValue(_ConfigExecutable, out var command) || command?.UntypedValue == null || string.IsNullOrEmpty(command.UntypedValue.ToString()))
            {
                _logger.Error("No Command defined!", arg, command);
                return "No Command defined!";
            }

            _ = arg.TryGetConfigValue(_ConfigArguments, out var arguments);

            bool waitForExit = false;
            if (arg.TryGetConfigValue(_ConfigWaitForExit, out var waitForExitParameter) && waitForExitParameter?.UntypedValue is bool b)
            {
                waitForExit = b;
            }

            try
            {
                var process = Process.Start(new ProcessStartInfo(command.UntypedValue.ToString(), arguments?.UntypedValue?.ToString())
                {
                    UseShellExecute = true
                });
                if (waitForExit)
                {
                    process.WaitForExit();
                    _logger.Debug($"Successfully exited. ExitCode: {process.ExitCode}", arg, command);
                    return $"Successfully exited. ExitCode: {process.ExitCode}";
                }
            }
            catch (Exception e)
            {
                _logger.Error("Could not execute command", arg, command, e);
                return "Could not execute command";
            }

            _logger.Debug("Successfully started!", arg, command);
            return "Successfully Started!";
        }

        public override string SymbolicName => "ShellExecute";

        public override View View { get; }

    }
}