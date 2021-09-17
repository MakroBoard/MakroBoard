#if WINDOWS
using Hardcodet.Wpf.TaskbarNotification;
#endif
using System;
using System.Runtime.InteropServices;

namespace MakroBoard.Tray
{
    public class TrayIcon: ITrayIcon
    {
        private ITrayIcon _InternalTrayIcon;

        public TrayIcon()
        {
            if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
            {
                _InternalTrayIcon = new MacOsTrayIcon();
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
            {
                _InternalTrayIcon = new WindowsTrayIcon();
            }
            else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
            {
                _InternalTrayIcon = new LinuxTrayIcon();
            }
            else
            {
                throw new PlatformNotSupportedException();
            }
        }

        public void Show()
        {
            _InternalTrayIcon.Show();
        }
    }

    internal interface ITrayIcon
    {
        void Show();
    }

    internal class WindowsTrayIcon : ITrayIcon
    {

#if WINDOWS
        private TaskbarIcon _TaskbarIcon;
#endif

        public void Show()
        {
#if WINDOWS
            _TaskbarIcon = new TaskbarIcon {
                Icon = System.Drawing.Icon.ExtractAssociatedIcon(@"C:\Users\Andy\Pictures\hahnlogo.png"),
            };


            _TaskbarIcon.TrayLeftMouseDown += (s,a) => _TaskbarIcon.Dispose();
#else

            throw new NotImplementedException();
#endif
        }
    }

    internal class LinuxTrayIcon : ITrayIcon
    {
        public void Show()
        {
            throw new NotImplementedException();
        }
    }


    internal class MacOsTrayIcon : ITrayIcon
    {
        public void Show()
        {
            throw new NotImplementedException();
        }
    }
}
