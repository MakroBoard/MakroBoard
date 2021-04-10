namespace MakroBoard.PluginContract.Views
{
    public sealed class ImageView : View
    {
        public ImageView() : base(string.Empty)
        {
        }

        public override ViewType Type => ViewType.Image;
    }
}
