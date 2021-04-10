using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MakroBoard.Data
{
    public class Group
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public int Witdh { get; set; }
        public int Height { get; set; }
        public string SymbolicName { get; set; }
        public int PageID  { get; set; }
        [ForeignKey("PageID")]
        public Page Page { get; set; }
        public int Order {get; set;}
        public List<Panel> Panels {get; set;}

    }


}