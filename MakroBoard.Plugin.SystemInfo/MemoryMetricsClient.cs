using System;
using System.Diagnostics;
using System.Globalization;
using System.Runtime.InteropServices;

namespace MakroBoard.Plugin.SystemInfo
{
    public static class MemoryMetricsClient
    {
        public static MemoryMetrics GetMetrics()
        {
            if (IsUnix())
            {
                return GetUnixMetrics();
            }
            if (IsMacOS())
            {
                return GetMacOSMetrics();
            }
            return GetWindowsMetrics();
        }

        private static bool IsUnix()
        {
            var isUnix = RuntimeInformation.IsOSPlatform(OSPlatform.Linux);
            return isUnix;
        }
        private static bool IsMacOS()
        {
            var isMacOS = RuntimeInformation.IsOSPlatform(OSPlatform.OSX);

            return isMacOS;
        }

        private static MemoryMetrics GetWindowsMetrics()
        {
            var output = "";

            var info = new ProcessStartInfo
            {
                FileName = "wmic",
                Arguments = "OS get FreePhysicalMemory,TotalVisibleMemorySize /Value",
                RedirectStandardOutput = true,
            };

            using (var process = Process.Start(info))
            {
                output = process.StandardOutput.ReadToEnd();
            }

            var lines = output.Trim().Split("\n");
            var freeMemoryParts = lines[0].Split("=", StringSplitOptions.RemoveEmptyEntries);
            var totalMemoryParts = lines[1].Split("=", StringSplitOptions.RemoveEmptyEntries);

            var total = Math.Round(double.Parse(totalMemoryParts[1], CultureInfo.InvariantCulture) / 1024, 0);
            var free = Math.Round(double.Parse(freeMemoryParts[1], CultureInfo.InvariantCulture) / 1024, 0);

            var metrics = new MemoryMetrics
            {
                Total = total,
                Free = free,
                Used = total - free,
            };

            return metrics;
        }

        private static MemoryMetrics GetUnixMetrics()
        {
            var output = "";

            var info = new ProcessStartInfo("free -m")
            {
                FileName = "/bin/bash",
                Arguments = "-c \"free -m\"",
                RedirectStandardOutput = true,
            };

            using (var process = Process.Start(info))
            {
                output = process.StandardOutput.ReadToEnd();
                Console.WriteLine(output, CultureInfo.InvariantCulture);
            }

            var lines = output.Split("\n");
            var memory = lines[1].Split(" ", StringSplitOptions.RemoveEmptyEntries);

            var metrics = new MemoryMetrics
            {
                Total = double.Parse(memory[1], CultureInfo.InvariantCulture),
                Used = double.Parse(memory[2], CultureInfo.InvariantCulture),
                Free = double.Parse(memory[3], CultureInfo.InvariantCulture),
            };

            return metrics;
        }
        private static MemoryMetrics GetMacOSMetrics()
        {
            var output = "";


            var totalinfo = new ProcessStartInfo("sysctl hw.memsize | awk '{print $2}'")
            {
                FileName = "/bin/bash",
                Arguments = "-c \"sysctl hw.memsize | awk '{print $2}'\"",
                RedirectStandardOutput = true,
            };

            var freeinfo = new ProcessStartInfo("vm_stat | grep free | awk '{print $3}' | sed 's/\\.//'")
            {
                FileName = "/bin/bash",
                Arguments = "-c \"vm_stat | grep free | awk '{print $3}' | sed 's/\\.//' \"",
                RedirectStandardOutput = true,
            };

            using (var process = Process.Start(totalinfo))
            {
                output = process.StandardOutput.ReadToEnd();
            }

            var totalmem = (Convert.ToInt64(output, CultureInfo.InvariantCulture) / 1024 / 1024);

            using (var process = Process.Start(freeinfo))
            {
                output = process.StandardOutput.ReadToEnd();
            }

            var freemem = ((Convert.ToInt64(output, CultureInfo.InvariantCulture) * 4096) / 1048576);

            var metrics = new MemoryMetrics
            {
                Total = totalmem,
                Used = totalmem - freemem,
                Free = freemem,
            };

            return metrics;
        }
    }
}
