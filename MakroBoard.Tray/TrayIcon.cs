using MakroBoard.Tray.Menu;
using System;
using System.Runtime.InteropServices;

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
        }

        public void Remove()
        {
            _InternalTrayIcon.Remove();
        }
    }
}
