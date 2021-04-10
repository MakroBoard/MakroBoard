using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MakroBoard.Data
{
    public class ConfigParameter
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public ConfigParameterType ConfigParameterType { get; set; }
        public string SymbolicName { get; set; }
        public string Value { get; set; }
        public int PanelID  {get; set;}
        [ForeignKey("PanelID")]
        public Panel Panel {get; set;}
    }

    public enum ConfigParameterType
    {
        Control,
        View
    }

}