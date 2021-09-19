using System.Collections.Generic;

namespace MakroBoard.Tray.Menu
{
    public interface ITrayMenu
    {
        public IReadOnlyList<ITrayMenuItem> MenuEntries { get; }
    }
}
