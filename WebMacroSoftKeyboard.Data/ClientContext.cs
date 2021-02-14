using EntityFrameworkCore.Triggers;
using Microsoft.EntityFrameworkCore;

namespace WebMacroSoftKeyboard.Data
{
    public class ClientContext : DbContextWithTriggers
    {
        public ClientContext(DbContextOptions<ClientContext> options) : base(options)
        {
        }

        public DbSet<Client> Clients { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Client>().ToTable("Client");
        }
    }
}