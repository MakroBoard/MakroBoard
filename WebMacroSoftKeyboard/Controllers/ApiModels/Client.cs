using System;

namespace WebMacroSoftKeyboard.Controllers.ApiModels
{
    public class Client
    {
        public int ID { get; set; }
        public int Code { get; set; }
        public string ValidUntil { get; set; }
        public string Token { get; set; }
        public string ClientIp { get; set; }
        public string RegisterDate { get; set; }
        public string LastConnection { get; set; }
        public int State { get; set; }
    }
}
