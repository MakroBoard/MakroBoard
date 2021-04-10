using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System;
using MakroBoard.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text.Unicode;
using System.Text;
using NLog.Web;

namespace MakroBoard
{
    public class Program
    {
        public static void Main(string[] args)
        {
            // NLog: setup the logger first to catch all errors
            var logger = NLog.Web.NLogBuilder.ConfigureNLog("nlog.config").GetCurrentClassLogger();
            try
            {
                logger.Debug("init log");
                logger.Debug($"Using Data Directory: { Constants.DataDirectory}");
                InitializeDataDir();
                InitializeInstanceSeed();

                var host = CreateHostBuilder(args).Build();
                using var scope = host.Services.CreateScope();

                var services = scope.ServiceProvider;

                CreateDbIfNotExists(services);

                host.Run();
            }
            catch (Exception ex)
            {
                //NLog: catch setup errors
                logger.Error(ex, "Stopped program because of exception");
                throw;
            }
            finally
            {
                // Ensure to flush and stop internal timers/threads before application-exit (Avoid segmentation fault on Linux)
                NLog.LogManager.Shutdown();
            }

        }


        private static void InitializeInstanceSeed()
        {
            if (File.Exists(Constants.SeedFileName))
            {
                Constants.Seed = File.ReadAllText(Constants.SeedFileName);
            }
            else
            {

                Constants.Seed = Encoding.UTF8.GetString(SHA512.Create().ComputeHash(Encoding.UTF8.GetBytes($"WMSK_{DateTime.Now:O}{new Random().Next()}")));
                File.WriteAllText(Constants.SeedFileName, Constants.Seed);
            }
        }

        private static void InitializeDataDir()
        {
            if (!Directory.Exists(Constants.DataDirectory))
            {
                Directory.CreateDirectory(Constants.DataDirectory);
            }
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>()
                    .ConfigureLogging(logging =>
                    {
                        logging.ClearProviders();
                        logging.SetMinimumLevel(LogLevel.Trace);
                    }).UseNLog();
                });

        private static void CreateDbIfNotExists(IServiceProvider services)
        {
            try
            {
                var context = services.GetRequiredService<DatabaseContext>();
                DatabaseInitializer.Initialize(context);
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred creating the DB.");
            }
        }
    }
}
