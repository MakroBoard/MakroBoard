using System;

namespace MakroBoard.Controllers.ApiModels
{
    public class Panel
    {
        public int ID { get; set; }
        public int Witdh { get; set; }
        public int Height { get; set; }
        public string PluginName { get; set; }
        public string SymbolicName { get; set; }
        public string ConfigData { get; set; }
    }

}
