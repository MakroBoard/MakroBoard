using System;

namespace MakroBoard.ApiModels
{
    public class Request
    {

    }

    public class Response
    {
        public ResponseStatus Status { get; set; }

        public string Error { get; set; }
    }

    public enum ResponseStatus
    {
        Ok,
        Error
    }

    public class RequestTokensResponse : Response
    {
        public RequestTokensResponse(Client[] clients)
        {
            Clients = clients;
        }

        public Client[] Clients { get; } 
    }

    public class CheckTokenResponse : Response
    {
        public CheckTokenResponse(bool isValid)
        {
            IsValid = isValid;
        }

        public bool IsValid { get; }
    }

    public class SubmitCodeRequest : Request
    {
        public SubmitCodeRequest(int code)
        {
            Code = code;
        }

        public int Code { get; }
    }

    public class SubmitCodeResponse : Response
    {
        public SubmitCodeResponse(DateTime validUntil)
        {
            ValidUntil = validUntil;
        }

        public DateTime ValidUntil { get; }
    }

    public class ConfirmClientRequest : Request
    {
        public Client Client { get; set; }
    }

    public class ConfirmClientResponse : Response
    {

    }

    public class RemoveClientRequest : Request
    {

        public Client Client { get; set; }
    }

    public class RemoveClientResponse : Response
    {

    }
}
