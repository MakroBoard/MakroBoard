using System;
using System.Collections.Generic;

namespace MakroBoard.Tray.Menu
{
    public class TrayMenuItem : ITrayMenuItem
    {
        private TrayMenuItem(string title)
        {
            Title = title;
        }

        public TrayMenuItem(string title, Action<ITrayMenuItem> clicked) : this(title)
        {
            Clicked = clicked;
        }

        public TrayMenuItem(string title, IReadOnlyList<ITrayMenuItem> menuEntries) : this(title)
        {
            MenuEntries = menuEntries;
        }

        public string Title { get; }

        public Action<ITrayMenuItem> Clicked { get; }



        public IReadOnlyList<ITrayMenuItem> MenuEntries { get; }
    }
}
