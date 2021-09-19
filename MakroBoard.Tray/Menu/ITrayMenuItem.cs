using System;
using System.Collections.Generic;

namespace MakroBoard.Tray.Menu
{
    public interface ITrayMenuItem
    {
        public string Title { get; }

        public Action<ITrayMenuItem> Clicked { get; }

        public IReadOnlyList<ITrayMenuItem> MenuEntries { get; }
    }
}
