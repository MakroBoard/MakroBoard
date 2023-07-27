namespace MakroBoard.ApiModels
{
    public class ExecuteResponse : Response
    {
        public ExecuteResponse(string result)
        {
            Result = result;
        }

        public string Result { get; }
    }
}
