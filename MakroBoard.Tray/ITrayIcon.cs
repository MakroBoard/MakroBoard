using MakroBoard.Tray.Menu;

namespace MakroBoard.Tray
{
    internal interface ITrayIcon
    {
        void Show(ITrayMenu trayMenu);

        void Remove();
    }
}
