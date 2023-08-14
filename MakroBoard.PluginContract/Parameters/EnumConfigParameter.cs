using System.Collections.Generic;

namespace MakroBoard.PluginContract.Parameters
{
    public class EnumConfigParameter : ConfigParameter
    {
        public EnumConfigParameter(string symbolicName, LocalizableString label, IReadOnlyCollection<EnumItem> enumItems, string defaultEnumItemId) : base(symbolicName, label)
        {
            EnumItems = enumItems;
            DefaultEnumItemId = defaultEnumItemId;
        }

        public IReadOnlyCollection<EnumItem> EnumItems { get; }

        public string DefaultEnumItemId { get; }

        public class EnumItem
        {
            public string Id { get; }

            public EnumItem(string id, LocalizableString label)
            {
                Id = id;
                Label = label;
            }

            public LocalizableString Label { get; }
        }
    }
}
