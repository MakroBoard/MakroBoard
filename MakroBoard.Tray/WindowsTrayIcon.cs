#if WINDOWS
using Hardcodet.Wpf.TaskbarNotification;
using System.Windows.Media.Imaging;
#endif
using System;
using System.Windows.Controls;
using System.Windows.Forms;

namespace MakroBoard.Tray
{
    internal class WindowsTrayIcon : ITrayIcon
    {
#if WINDOWS
        private TaskbarIcon _TaskbarIcon;
#endif

        private ITrayIconCallback _TrayIconCallback;

        public WindowsTrayIcon(ITrayIconCallback trayIconCallback)
        {
            _TrayIconCallback = trayIconCallback;
        }

        public void Show()
        {
#if WINDOWS
            var iconPath = System.Reflection.Assembly.GetEntryAssembly().Location;

            var contextMenu = new System.Windows.Controls.ContextMenu
            {
                Items =
                {
                   new System.Windows.Controls.MenuItem
                   {
                       Header = "Test",
                   }
                }
            };

            _TaskbarIcon = new TaskbarIcon
            {
                //Icon = System.Drawing.Icon.ExtractAssociatedIcon(iconPath),
                IconSource = new BitmapImage(new Uri("pack://application:,,,/MakroBoard;component/app_icon.ico")),
                ToolTipText = "MakroBoard",
                ToolTip = "MakroBoard TT",
                ContextMenu = contextMenu,
                Visibility = System.Windows.Visibility.Visible,
                MenuActivation = PopupActivationMode.LeftClick,
                PopupActivation = PopupActivationMode.RightClick,
                DataContext = this,
                TrayToolTip = new TextBlock {  Text = "ABC"},
                TrayPopup = new TextBlock {  Text = "DEF"}
            };
            //_TaskbarIcon.TrayLeftMouseDown += (s, a) => ;
            Application.Run();
#endif
        }
    }
}
