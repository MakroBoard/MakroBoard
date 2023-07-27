using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class PanelData
    {
        public PanelData(int panelId, string controlName, List<ConfigValue> values)
        {
            PanelId = panelId;
            ControlName = controlName;
            Values = values;
        }

        public int PanelId { get; }

        public string ControlName { get; }

        public IList<ConfigValue> Values { get; }
    }
}