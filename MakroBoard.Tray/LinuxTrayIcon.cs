using MakroBoard.Tray.Menu;
using System;
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
#endif

        public void Show(ITrayMenu trayMenu)
        {
#if Linux
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

            MenuItem menuItemQuit = new MenuItem("Quit");

        
            popupMenu.Add(menuItemQuit);


            Gtk.Image quitimg = new Gtk.Image(Stock.Quit, IconSize.Menu);
            Gtk.Image appimg = new Gtk.Image(Stock.Quit, IconSize.Menu);



            menuItemQuit.Activated += delegate { Application.Quit(); _TrayIconCallback.Shutdown(); }; //todo application exit call
            menuItemOpenMakroBoard.Activated += delegate { _TrayIconCallback.Open(); }; //todo open makroboard

            popupMenu.ShowAll();
            popupMenu.Popup();
        }
#endif
    }
}
