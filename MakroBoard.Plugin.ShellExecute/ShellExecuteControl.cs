using System;
using System.Diagnostics;
using NLog;
using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System.Globalization;

namespace MakroBoard.Plugin.ShellExecute
{
    internal sealed class ShellExecuteControl : Control
    {
        private readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private const string _ConfigExecutable = "executable";
        private const string _ConfigArguments = "arguments";
        private const string _ConfigWaitForExit = "Wait for Exit";

        public ShellExecuteControl() : base()
        {
            View = new ButtonView($"Execute", ExecuteCommand);
            AddConfigParameter(new StringConfigParameter(_ConfigExecutable, new LocalizableString(Resource.ResourceManager, nameof(Resource.Application)), string.Empty, ".*"));
            AddConfigParameter(new StringConfigParameter(_ConfigArguments, new LocalizableString(Resource.ResourceManager, nameof(Resource.Arguments)), string.Empty, ".*"));
            AddConfigParameter(new BoolConfigParameter(_ConfigWaitForExit, new LocalizableString(Resource.ResourceManager, nameof(Resource.WaitForExit)), defaultValue: false));
        }

        private string ExecuteCommand(ParameterValues arg)
        {
            if (!arg.TryGetConfigValue(_ConfigExecutable, out var command) || command?.UntypedValue == null || string.IsNullOrEmpty(command.UntypedValue.ToString()))
            {
                _Logger.Error("No Command defined!", arg, command);
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
                    UseShellExecute = true,
                });
                if (waitForExit)
                {
                    process.WaitForExit();
                    _Logger.Debug(CultureInfo.InvariantCulture, "Successfully exited. ExitCode: {exitCode}", process.ExitCode);
                    return string.Create(CultureInfo.InvariantCulture, $"Successfully exited. ExitCode: {process.ExitCode}");
                }
            }
            catch (Exception e)
            {
                _Logger.Error(e, "Could not execute command");
                return "Could not execute command";
            }

            _Logger.Debug("Successfully started!");
            return "Successfully Started!";
        }

        public override string SymbolicName => "ShellExecute";

        public override View View { get; }

    }
}