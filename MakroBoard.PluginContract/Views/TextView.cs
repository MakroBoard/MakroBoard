using MakroBoard.PluginContract.Parameters;

namespace MakroBoard.PluginContract.Views
{
    public sealed class TextView : View
    {

        public TextView(string label) : base(label)
        {
            TextParameter = new StringConfigParameter("text", LocalizableString.Empty, string.Empty);
            AddPluginParameter(TextParameter);
        }

        public StringConfigParameter TextParameter { get; }

        public override ViewType Type => ViewType.Text;
    }
}
