using System;
using System.IO;

namespace MakroBoard
{
    public static class Constants
    {
        public static string DataDirectory { get; } = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "MakroBoard");

        public static string SeedFileName { get; } = Path.Combine(DataDirectory, "wmsk.seed");

        public static string Seed { get; set; }
    }
}
