namespace MakroBoard.ApiModels
{
    public class EnumItem
    {
        public EnumItem(string id, LocalizableString label)
        {
            Id = id;
            Label = label;
        }

        public string Id { get; }

        public LocalizableString Label { get; }
    }
}
