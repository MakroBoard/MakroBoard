using System;
using System.IO;

namespace WebMacroSoftKeyboard
{
    public static class Constants
    {
        public static string DataDirectory => Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "WebMacroSoftKeyboard");
    }
}
