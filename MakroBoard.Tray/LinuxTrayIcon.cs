using System;
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
            Application.Init();
            _TrayMenu = trayMenu;
            var app = new Application("app.makroboard.client.tray", GLib.ApplicationFlags.None);
            app.Register(GLib.Cancellable.Current);

            trayIcon = new StatusIcon(new Pixbuf("/home/volza/projects/MakroBoard/MakroBoard/Design/Logo_small_256_256.png"));
            trayIcon.Visible = true;
            trayIcon.PopupMenu += OnTrayIconPopup;
            
            Application.Run();
#endif
        }

        public void Remove()
        {
#if Linux
            Application.Quit();
#endif
        }

#if Linux
        void OnTrayIconPopup(object o, EventArgs args)
        {
            Gtk.Menu popupMenu = new Gtk.Menu();

            foreach(var menuEntry in _TrayMenu.MenuEntries)
            {
                MenuItem menuItem = new MenuItem(menuEntry.Title);
                menuItem.Activated += (s,a) => menuEntry.Clicked?.Invoke(menuEntry);
                popupMenu.Add(menuItem);
            }

            popupMenu.ShowAll();
            popupMenu.Popup();
        }
#endif
    }
}
