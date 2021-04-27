using System;
using System.Collections.Generic;

namespace MakroBoard.Controllers.ApiModels
{
    public class Panel
    {
        public int ID { get; set; }
        public int Witdh { get; set; }
        public int Height { get; set; }
        public string PluginName { get; set; }
        public string SymbolicName { get; set; }
        public List<ConfigValue> ConfigValues { get; set; }
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
        public PanelData(int panelId, List<ConfigValue> values)
        {
            PanelId = panelId;
            Values = values;
        }

        public int PanelId { get; }
        public List<ConfigValue> Values { get; }
    }
}