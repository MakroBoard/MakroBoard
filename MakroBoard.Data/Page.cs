using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MakroBoard.Data
{
    public class Page
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }

        public string SymbolicName { get; set; }

        public string Label { get; set; }

        public string Icon { get; set; }

        [InverseProperty("Page")]
        public IList<Group> Groups { get; set; }

    }


}