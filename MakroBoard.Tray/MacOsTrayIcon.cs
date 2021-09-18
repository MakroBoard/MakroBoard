using System;

namespace MakroBoard.Tray
{
    internal class MacOsTrayIcon : ITrayIcon
    {
        private ITrayIconCallback _TrayIconCallback;

        public MacOsTrayIcon(ITrayIconCallback trayIconCallback)
        {
            _TrayIconCallback = trayIconCallback;
        }

        public void Show()
        {
            throw new NotImplementedException();
        }
    }
}
