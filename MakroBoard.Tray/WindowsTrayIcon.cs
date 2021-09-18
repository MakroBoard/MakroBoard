#if WINDOWS
using Hardcodet.Wpf.TaskbarNotification;
using System.Windows.Media.Imaging;
#endif
using System;
using System.Windows.Controls;
using MakroBoard.Tray.Menu;
using System.Windows.Input;
using System.Diagnostics;

namespace MakroBoard.Tray
{
    internal class WindowsTrayIcon : ITrayIcon
    {
#if WINDOWS
        private TaskbarIcon _TaskbarIcon;
#endif

        public void Show(ITrayMenu trayMenu)
        {
#if WINDOWS
            var iconPath = System.Reflection.Assembly.GetEntryAssembly().Location;

            var contextMenu = new ContextMenu();

            foreach (var menuEntry in trayMenu.MenuEntries)
            {
                // TODO SubMenus
                contextMenu.Items.Add(new MenuItem { Header = menuEntry.Title, Command = new RelayCommand(o => menuEntry.Clicked?.Invoke(menuEntry)) });
            }


            _TaskbarIcon = new TaskbarIcon
            {
                //Icon = System.Drawing.Icon.ExtractAssociatedIcon(iconPath),
                IconSource = new BitmapImage(new Uri("pack://application:,,,/MakroBoard;component/app_icon.ico")),
                ToolTipText = "MakroBoard",
                ContextMenu = contextMenu,
                Visibility = System.Windows.Visibility.Visible,
                MenuActivation = PopupActivationMode.LeftOrRightClick,
                //DataContext = this,
            };
            //_TaskbarIcon.TrayLeftMouseDown += (s, a) => ;
#endif
        }

        public class RelayCommand : ICommand
        {

            readonly Action<object> _execute;
            readonly Predicate<object> _canExecute;


            public RelayCommand(Action<object> execute) : this(execute, null) { }
            public RelayCommand(Action<object> execute, Predicate<object> canExecute)
            {
                _execute = execute ?? throw new
                ArgumentNullException("execute"); _canExecute = canExecute;
            }

            [DebuggerStepThrough]
            public bool CanExecute(object parameter)
            {
                return _canExecute == null ? true : _canExecute(parameter);
            }
            public event EventHandler CanExecuteChanged
            {
                add { CommandManager.RequerySuggested += value; }
                remove { CommandManager.RequerySuggested -= value; }
            }
            public void Execute(object parameter) { _execute(parameter); }

        }
    }
}
