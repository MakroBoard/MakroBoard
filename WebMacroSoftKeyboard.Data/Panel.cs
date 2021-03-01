using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebMacroSoftKeyboard.Data
{
    public class Panel
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public int Witdh { get; set; }
        public int Height { get; set; }
        public string PluginName { get; set; }
        public string SymbolicName { get; set; }
        public int Order {get; set;}
        public int GroupID  { get; set; }
        [ForeignKey("GroupID")]
        public Group Group {get; set;}
        public List<ConfigParameter> ConfigParameters {get; set;}
        
    }


}