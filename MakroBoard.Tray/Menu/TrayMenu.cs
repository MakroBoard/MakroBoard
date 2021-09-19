using System.Collections.Generic;

namespace MakroBoard.Tray.Menu
{
    public class TrayMenu : ITrayMenu
    {
        public TrayMenu(IReadOnlyList<ITrayMenuItem> menuEntries)
        {
            MenuEntries = menuEntries;
        }
      
        public IReadOnlyList<ITrayMenuItem> MenuEntries { get; }
    }
}
