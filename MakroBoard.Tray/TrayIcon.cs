using System;
using System.Runtime.InteropServices;

namespace MakroBoard.Tray
{
    -public class TrayIcon : ITrayIcon
    {
        private ITrayIcon _InternalTrayIcon;

        public TrayIcon(ITrayIconCallback trayIconCallback)
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                _InternalTrayIcon = new MacOsTrayIcon(trayIconCallback);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                _InternalTrayIcon = new WindowsTrayIcon(trayIconCallback);
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                _InternalTrayIcon = new LinuxTrayIcon(trayIconCallback);
            }
            else
            {
                throw new PlatformNotSupportedException();
            }
        }

        public void Show()
        {
            _InternalTrayIcon.Show();
        }
    }

    internal interface ITrayIcon
    {
        void Show();
    }

    public interface ITrayIconCallback
    {
        void Shutdown();
    }
}
