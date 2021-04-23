using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MakroBoard.Data
{
    public class ConfigParameterValue
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public string SymbolicName { get; set; }
        public string Value { get; set; }
        [ForeignKey("Panel")]
        public int PanelID  {get; set; }

        [JsonIgnore]
        public Panel Panel {get; set;}
    }
}