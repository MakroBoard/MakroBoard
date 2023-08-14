using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MakroBoard.ApiModels
{
    public class EnumItems : Collection<EnumItem>
    {
        public EnumItems()
        {

        }

        public EnumItems(IList<EnumItem> enumItems) : base(enumItems)
        {

        }
    }
}
