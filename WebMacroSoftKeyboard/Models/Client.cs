using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebMacroSoftKeyboard.Models
{
    public class Client
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public int Code { get; set; }
        public string Token { get; set; }
        public string ClientIp { get; set; }
        public DateTime RegisterDate { get; set; }
        public DateTime LastConnection { get; set; }
    }
}