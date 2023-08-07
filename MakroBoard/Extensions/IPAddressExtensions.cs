using System;
using System.Linq;
using System.Net;

namespace MakroBoard.Extensions
{
    internal static class IPAddressExtensions
    {
        public static bool IsLocalHost(this IPAddress ipAddress)
        {
            if (IPAddress.IsLoopback(ipAddress))
            {
                return true;
            }

            var hostAdresses = Dns.GetHostAddresses(string.Empty);

            var ipV4 = ipAddress.IsIPv4MappedToIPv6 ? ipAddress.MapToIPv4() : ipAddress;

            if (hostAdresses.Contains(ipV4))
            {
                return true;
            }

            return false;
        }
    }
}
