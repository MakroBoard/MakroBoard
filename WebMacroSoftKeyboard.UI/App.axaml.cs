using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using System;
using WebMacroSoftKeyboard.UI.ViewModels;
using WebMacroSoftKeyboard.UI.Views;

namespace WebMacroSoftKeyboard.UI
{
    public class App : Application
    {
        private IServiceProvider _Services;

        public App()
        {

        }

        public App(IServiceProvider services)
        {
            _Services = services;
        }

        public override void Initialize()
        {
            AvaloniaXamlLoader.Load(this);
        }

        public override void OnFrameworkInitializationCompleted()
        {
            if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
            {
                desktop.MainWindow = new MainWindow
                {
                    DataContext = new MainWindowViewModel(_Services),
                };
            }

            base.OnFrameworkInitializationCompleted();
        }
    }
}