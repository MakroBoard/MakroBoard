using Microsoft.EntityFrameworkCore;
using NLog;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.Data
{
    public static class DatabaseInitializer
    {
        public static async Task Initialize(DatabaseContext context)
        {
            LogManager.GetCurrentClassLogger().Info($"Initialize Database: {context.Database.GetConnectionString()}");
            await context.Database.EnsureCreatedAsync();
            context.Database.GetConnectionString();
            if (context.Sessions.Any())
            {
                context.Sessions.RemoveRange(context.Sessions);
            }
          
            await context.SaveChangesAsync();
        }
    }
}
