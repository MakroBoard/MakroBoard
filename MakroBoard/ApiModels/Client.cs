﻿using System;

namespace MakroBoard.ApiModels
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

        public static Client FromDataClient(Data.Client dataClient)
        {
            return new Client
            {
                ID = dataClient.ID,
                Code = dataClient.Code,
                ValidUntil = dataClient.ValidUntil.ToString(),
                Token = dataClient.Token,
                ClientIp = dataClient.ClientIp,
                RegisterDate = dataClient.RegisterDate.ToString(),
                LastConnection = dataClient.LastConnection.ToString(),
                State = (int)dataClient.State,
            };
        }
    }
}
