#if WINDOWS
using Hardcodet.Wpf.TaskbarNotification;
using System.Windows.Input;
using System.Windows.Controls;
using System.Windows.Forms;
#endif
using System;
using MakroBoard.Tray.Menu;
using System.Diagnostics;

namespace MakroBoard.Tray
{
    internal class WindowsTrayIcon : ITrayIcon
    {
        public void Show(ITrayMenu trayMenu)
        {
#if WINDOWS

            var contextMenu = new ContextMenu();

            foreach (var menuEntry in trayMenu.MenuEntries)
            {
                // TODO SubMenus
                contextMenu.Items.Add(new MenuItem { Header = menuEntry.Title, Command = new RelayCommand(o => menuEntry.Clicked?.Invoke(menuEntry)) });
            }

            var iconPath = Process.GetCurrentProcess().MainModule.FileName;

            _ = new TaskbarIcon
            {
                Icon = System.Drawing.Icon.ExtractAssociatedIcon(iconPath),
                ToolTipText = "MakroBoard",
                ContextMenu = contextMenu,
                Visibility = System.Windows.Visibility.Visible,
                MenuActivation = PopupActivationMode.LeftOrRightClick,
            };
            Application.Run();
#endif
        }

        public void Remove()
        {
#if WINDOWS
            Application.Exit();
#endif
        }

#if WINDOWS

        public class RelayCommand : ICommand
        {

            readonly Action<object> _execute;
            readonly Predicate<object> _canExecute;


            public RelayCommand(Action<object> execute) : this(execute, null) { }
            public RelayCommand(Action<object> execute, Predicate<object> canExecute)
            {
                _execute = execute ?? throw new
                ArgumentNullException(nameof(execute)); _canExecute = canExecute;
            }

            [DebuggerStepThrough]
            public bool CanExecute(object parameter)
            {
                return _canExecute == null || _canExecute(parameter);
            }
            public event EventHandler CanExecuteChanged
            {
                add { CommandManager.RequerySuggested += value; }
                remove { CommandManager.RequerySuggested -= value; }
            }
            public void Execute(object parameter) { _execute(parameter); }

        }
#endif
    }
}
