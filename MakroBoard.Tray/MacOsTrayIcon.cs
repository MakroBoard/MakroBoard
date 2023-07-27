using MakroBoard.Tray.Menu;
using System;

namespace MakroBoard.Tray
{
    internal sealed class MacOsTrayIcon : ITrayIcon
    {
        public void Remove()
        {
            throw new NotSupportedException();
        }

        public void Show(ITrayMenu trayMenu)
        {
            throw new NotSupportedException();
        }
    }
}
