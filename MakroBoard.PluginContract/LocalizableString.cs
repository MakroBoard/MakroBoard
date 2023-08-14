using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Resources;

namespace MakroBoard.PluginContract
{
    public class LocalizableString
    {
        private static ConcurrentDictionary<ResourceManager, IList<CultureInfo>> _CultureCache = new ConcurrentDictionary<ResourceManager, IList<CultureInfo>>();

        public IDictionary<CultureInfo, string> LocaleStrings { get; set; }
        public static LocalizableString Empty => null;

        public LocalizableString()
        {

        }


        public LocalizableString(ResourceManager resourceManager, string resourceName)
        {
            var cultureInfos = _CultureCache.GetOrAdd(resourceManager, rm =>
            {
                var cultureInfos = new List<CultureInfo>();
                var cultures = CultureInfo.GetCultures(CultureTypes.AllCultures);
                foreach (CultureInfo culture in cultures)
                {
                    try
                    {
                        if (culture.Equals(CultureInfo.InvariantCulture)) continue; //do not use "==", won't work

                        ResourceSet rs = rm.GetResourceSet(culture, true, false);
                        if (rs != null)
                            cultureInfos.Add(culture);
                    }
                    catch (CultureNotFoundException)
                    {
                        //NOP
                    }
                }

                return cultureInfos;
            });


            LocaleStrings = cultureInfos.ToDictionary(c => c, c => resourceManager.GetString(resourceName, c));
        }
    }
}
