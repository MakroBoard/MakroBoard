namespace MakroBoard.ApiModels
{
    public class CheckTokenResponse : Response
    {
        public CheckTokenResponse(bool isValid)
        {
            IsValid = isValid;
        }

        public bool IsValid { get; }
    }
}
