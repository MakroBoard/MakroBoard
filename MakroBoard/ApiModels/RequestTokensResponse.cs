namespace MakroBoard.ApiModels
{
    public class RequestTokensResponse : Response
    {
        public RequestTokensResponse(Client[] clients)
        {
            Clients = clients;
        }

        public Client[] Clients { get; }
    }
}
