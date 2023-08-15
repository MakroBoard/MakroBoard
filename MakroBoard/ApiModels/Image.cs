namespace MakroBoard.ApiModels
{
    public class Image
    {
        public Image(string name, string type)
        {
            Name = name;
            Type = type;
        }

        public string Name { get; }

        public string Type { get; }
    }
}
