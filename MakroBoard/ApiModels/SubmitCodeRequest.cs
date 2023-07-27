namespace MakroBoard.ApiModels
{
    public class SubmitCodeRequest : Request
    {
        public SubmitCodeRequest(int code)
        {
            Code = code;
        }

        public int Code { get; }
    }
}
