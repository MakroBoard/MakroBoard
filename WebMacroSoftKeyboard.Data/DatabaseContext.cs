using EntityFrameworkCore.Triggers;
using Microsoft.EntityFrameworkCore;

namespace WebMacroSoftKeyboard.Data
{
    public class DatabaseContext : DbContextWithTriggers
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }

        public DbSet<Client> Clients { get; set; }
        public DbSet<Session> Sessions { get; set; }
        public DbSet<Panel> Panels { get; set; }
        public DbSet<Group> Groups { get; set; }
        public DbSet<Page> Pages { get; set; }
        public DbSet<ConfigParameter> ConfigParameters { get; set;}

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Client>().ToTable("Client");
            modelBuilder.Entity<Panel>().ToTable("Panels");
            modelBuilder.Entity<Group>().ToTable("Groups");
            modelBuilder.Entity<Page>().ToTable("Pages");
            modelBuilder.Entity<ConfigParameter>().ToTable("ConfigParameters");
        }
    }
}