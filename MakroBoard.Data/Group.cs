using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

namespace MakroBoard.Data
{
    public class Group
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }

        public int Witdh { get; set; }

        public int Height { get; set; }

        public string Label { get; set; }

        public string SymbolicName { get; set; }

        [ForeignKey("Page")]
        public int PageID  { get; set; }

        [JsonIgnore]
        public Page Page { get; set; }

        public int Order {get; set;}

        [InverseProperty("Group")]
        public List<Panel> Panels {get; set;}

    }


}