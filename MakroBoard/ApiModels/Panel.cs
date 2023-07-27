using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class Panel
    {
        public int ID { get; set; }
        public int Witdh { get; set; }
        public int Height { get; set; }
        public string PluginName { get; set; }
        public string SymbolicName { get; set; }
        public IList<ConfigValue> ConfigValues { get; set; }
        public int GroupId { get; set; }
    }


    public class ConfigParameterValue
    {
        public int ID { get; set; }

        public string SymbolicName { get; set; }

        public string Value { get; set; }

        public int PanelID { get; set; }
    }

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