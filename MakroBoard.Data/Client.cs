using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json.Serialization;

namespace MakroBoard.Data
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

        [JsonIgnore]
        public ICollection<Session> Sessions { get; set; }

        public void CreateNewToken(string seed)
        {
            byte[] bytes = SHA512.HashData(Encoding.UTF8.GetBytes(string.Create(CultureInfo.InvariantCulture, $"WMSK_{ClientIp}{Code}{DateTime.Now:O}{seed}{new Random().Next()}")));
            var token = Convert.ToBase64String(bytes);
            Token = token;
        }
    }
}
