using System;

namespace MakroBoard
{
    public class Localsettings
    {
        public int Port { get; set; } = 5001 ;

        public bool validatesettings()
        {
            if (Port == 0 || Port < 1024 || Port > 65535 )
            {
                return false;
            }

            return true;
        }
    }
}
