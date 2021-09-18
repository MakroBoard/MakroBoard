using MakroBoard.Tray.Menu;
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace MakroBoard.Tray
{
    public class TrayIcon : ITrayIcon
    {
        private ITrayIcon _InternalTrayIcon;

        public TrayIcon()
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                _InternalTrayIcon = new MacOsTrayIcon();
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                _InternalTrayIcon = new WindowsTrayIcon();
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                _InternalTrayIcon = new LinuxTrayIcon();
            }
            else
            {
                throw new PlatformNotSupportedException();
            }
        }

        public void Show(ITrayMenu trayMenu)
        {
            _InternalTrayIcon.Show(trayMenu);
            Application.Run();
        }

        public void Remove()
        {
            Application.Exit();
        }
    }
}
