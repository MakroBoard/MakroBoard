#if WINDOWS
#endif
using System;

namespace MakroBoard.Tray
{
    internal class LinuxTrayIcon : ITrayIcon
    {
        public void Show()
        {
            throw new NotImplementedException();
        }
    }
}
