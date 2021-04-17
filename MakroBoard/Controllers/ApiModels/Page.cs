namespace MakroBoard.Controllers.ApiModels
{
    public class Page
    {
        public string Label { get; set; }
        public string Icon { get; set; }
    }

    public class Group
    {
        public string Label { get; set; }
        public int PageID { get; set; }
    }
}
