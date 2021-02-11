using Microsoft.EntityFrameworkCore;
using WebMacroSoftKeyboard.Models;

namespace WebMacroSoftKeyboard.Data
{
    public class ClientContext : DbContext
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