using MakroBoard.Tray.Menu;
#if Linux
using Gtk;
using Gdk;
#endif

namespace MakroBoard.Tray
{
    internal class LinuxTrayIcon : ITrayIcon
    {
#if Linux
        private static StatusIcon trayIcon;
        private ITrayMenu _TrayMenu;
#endif

        public void Show(ITrayMenu trayMenu)
        {
#if Linux
            _TrayMenu = trayMenu;
            var app = new Application("app.makroboard.client.tray", GLib.ApplicationFlags.None);
            app.Register(GLib.Cancellable.Current);

            trayIcon = new StatusIcon(new Pixbuf("/home/volza/projects/MakroBoard/MakroBoard/Design/Logo_small_256_256.png"));
            trayIcon.Visible = true;
            trayIcon.PopupMenu += OnTrayIconPopup;

#endif
        }

#if Linux
        void OnTrayIconPopup(object o, EventArgs args)
        {
            Menu popupMenu = new Menu();

            MenuItem menuItemOpenMakroBoard = new MenuItem("Open MakroBoard");
            popupMenu.Add(menuItemOpenMakroBoard);

            foreach(var menuEntry in _TrayMenu.MenuEntries)
            {
                MenuItem menuItemQuit = new MenuItem(menuEntry.Title);
                //Gtk.Image quitimg = new Gtk.Image(Stock.Quit, IconSize.Menu);
                menuItemQuit.Activated += (s,a) => menuEntry.Clicked?.Invoke(menuEntry);
                
                popupMenu.Add(menuItemQuit);
            }

            Gtk.Image appimg = new Gtk.Image(Stock.Quit, IconSize.Menu);


            menuItemOpenMakroBoard.Activated += (s,a) => _TrayIconCallback.Open(); //todo open makroboard

            popupMenu.ShowAll();
            popupMenu.Popup();
        }
#endif
    }
}
