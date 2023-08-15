namespace MakroBoard.PluginContract
{
    public class Image
    {
        public Image(string name, ImageType type)
        {
            Name = name;
            Type = type;
        }

        public string Name { get; }

        public ImageType Type { get; }
    }
}
