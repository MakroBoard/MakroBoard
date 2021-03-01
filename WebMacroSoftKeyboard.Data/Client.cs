using System;
using System.Collections.Generic;
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
        public List<Session> Sessions { get; set; }
    }

    public enum ClientState
    {
        None,
        Confirmed,
        Blocked
    }

    public class Session
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public string ClientSignalrId { get; set; }
        public int ClientID { get; set; }
        [ForeignKey("ClientID")]
        public Client Client { get; set; }
    }
}
