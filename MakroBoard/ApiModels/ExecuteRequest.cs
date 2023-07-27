namespace MakroBoard.ApiModels
{
    public class ExecuteRequest : Request
    {
        public string SymbolicName { get; set; }

        public ConfigValues ConfigValues { get; set; }
    }
}
