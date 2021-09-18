using System;
using Gtk;
using Gdk;

namespace MakroBoard.Tray
{
    internal class LinuxTrayIcon : ITrayIcon
    {

        private static StatusIcon trayIcon;

        public void Show()
        {
            Application.Init();

            var app = new Application("app.makroboard.client.tray", GLib.ApplicationFlags.None);
            app.Register(GLib.Cancellable.Current);

            trayIcon = new StatusIcon(new Pixbuf ("/home/volza/projects/MakroBoard/MakroBoard/Design/Logo_small_256_256.png"));
            trayIcon.Visible = true;
            trayIcon.PopupMenu += OnTrayIconPopup;

            Application.Run();

        }
        
        static void OnTrayIconPopup (object o, EventArgs args) {
        Menu popupMenu = new Menu();

        ImageMenuItem menuItemOpenMakroBoard = new ImageMenuItem ("Open MakroBoard");
        ImageMenuItem menuItemQuit = new ImageMenuItem ("Quit");
        Gtk.Image quitimg = new Gtk.Image(Stock.Quit, IconSize.Menu);
        Gtk.Image appimg = new Gtk.Image(Stock.Quit, IconSize.Menu);
        
        
        menuItemOpenMakroBoard.Image = appimg;
        popupMenu.Add(menuItemOpenMakroBoard);

        menuItemQuit.Image = quitimg;
        popupMenu.Add(menuItemQuit);

        menuItemQuit.Activated += delegate { Application.Quit(); }; //todo application exit call
        menuItemOpenMakroBoard.Activated += delegate { }; //todo open makroboard

        popupMenu.ShowAll();
        popupMenu.Popup();
        }
    }
}
