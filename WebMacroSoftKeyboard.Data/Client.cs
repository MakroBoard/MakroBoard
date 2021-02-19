using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebMacroSoftKeyboard.Data
{
    public class Client
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public int Code { get; set; }
        public DateTime ValidUntil { get; set; }
        public string Token { get; set; }
        public string ClientIp { get; set; }
        public DateTime RegisterDate { get; set; }
        public DateTime LastConnection { get; set; }
        public ClientState State { get; set; }
    }

    public enum ClientState
    {
        None,
        Confirmed,
        Blocked
    }
}