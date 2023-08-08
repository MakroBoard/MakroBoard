using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class LocalizableString
    {
        public LocalizableString(Dictionary<string, string> localizedStrings)
        {
            LocalizedStrings = localizedStrings;
        }

        public Dictionary<string, string> LocalizedStrings { get;  }
    }
}
