using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

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
        public int PanelID  {get; set;}
        public Panel Panel {get; set;}
    }
}