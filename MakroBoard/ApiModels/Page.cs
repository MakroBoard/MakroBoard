namespace MakroBoard.ApiModels
{
    public class Page
    {
        public string Label { get; set; }
        public string Icon { get; set; }
    }

    public class Group
    {
        public int Id { get; set; }
        public string Label { get; set; }
        public int PageID { get; set; }
    }
}
