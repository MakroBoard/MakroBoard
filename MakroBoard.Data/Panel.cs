using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MakroBoard.Data
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

        public int Order {get; set; }

        [ForeignKey("Group")]
        public int GroupID  { get; set; }

        [JsonIgnore]
        public Group Group {get; set; }

        [InverseProperty("Panel")]
        public List<ConfigParameterValue> ConfigParameters {get; set;}

    }


}