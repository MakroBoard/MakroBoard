using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MakroBoard.Data
{
    public class Session
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int ID { get; set; }
        public string ClientSignalrId { get; set; }
        public int ClientID { get; set; }
        [ForeignKey("ClientID")]
        public Client Client { get; set; }
    }
}
