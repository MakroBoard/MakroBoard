#if WINDOWS
#endif
using System;

namespace MakroBoard.Tray
{
    internal class LinuxTrayIcon : ITrayIcon
    {
        private ITrayIconCallback _TrayIconCallback;

        public LinuxTrayIcon(ITrayIconCallback trayIconCallback)
        {
            _TrayIconCallback = trayIconCallback;
        }

        public void Show()
        {
            throw new NotImplementedException();
        }
    }
}
