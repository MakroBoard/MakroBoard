using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System;
using MakroBoard.Data;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using NLog.Web;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using MakroBoard.Plugin;
using MakroBoard.Tray;
using System.Threading;
using MakroBoard.Tray.Menu;
using System.Collections.Generic;
using System.Windows.Forms;

namespace MakroBoard
{
    public class Program
    {
        private static X509Certificate2 _Certificate;
        private static TrayIcon _TrayIcon;
        private IHost _Host;

        public static async Task Main(string[] args)
        {
            var program = new Program();
            await program.Start(args);
        }

        private async Task Start(string[] args)
        {
            // NLog: setup the logger first to catch all errors :)
            var logger = NLogBuilder.ConfigureNLog("nlog.config").GetCurrentClassLogger();
            try
            {
                ShowTrayIcon();

                logger.Debug("init log");
                logger.Debug($"Using Data Directory: { Constants.DataDirectory}");
                InitializeDataDir();
                await InitializeInstanceSeed();
                InitializeCertificate();

                using (_Host = CreateHostBuilder(args).Build())
                {
                    using var scope = _Host.Services.CreateScope();

                    var services = scope.ServiceProvider;

                    await CreateDbIfNotExists(services);
                    await LoadPlugins(services);

                    logger.Info("Server Started");

                    _Host.Run();
                }
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

        private void ShowTrayIcon()
        {
            var thread = new Thread(() =>
            {
                _TrayIcon = new TrayIcon();
                _TrayIcon.Show(new TrayMenu(new List<ITrayMenuItem>
                {
                    new TrayMenuItem("Beenden", async i =>
                    {
                        _TrayIcon.Remove();
                        await _Host?.StopAsync();
                    })
                }));
            });
#if WINDOWS
            thread.SetApartmentState(ApartmentState.STA);
#endif
            thread.Start();
        }

        private static async Task InitializeInstanceSeed()
        {
            if (File.Exists(Constants.SeedFileName))
            {
                Constants.Seed = await File.ReadAllTextAsync(Constants.SeedFileName);
            }
            else
            {
                Constants.Seed = Encoding.UTF8.GetString(SHA512.Create().ComputeHash(Encoding.UTF8.GetBytes($"WMSK_{DateTime.Now:O}{new Random().Next()}")));
                await File.WriteAllTextAsync(Constants.SeedFileName, Constants.Seed);
            }
        }

        private static void InitializeDataDir()
        {
            if (!Directory.Exists(Constants.DataDirectory))
            {
                Directory.CreateDirectory(Constants.DataDirectory);
            }
        }


        private static void InitializeCertificate()
        {
            var cert = Certificates.LoadCertificate("MakroBoard");
            if (cert == null)
            {
                cert = Certificates.GenerateCertificate("MakroBoard");
                Certificates.SaveCertificate(cert);
            }

            _Certificate = cert;
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
                    })
                    .UseNLog()
                    .UseUrls()
                    .UseKestrel(serverOptions =>
                    {
                        serverOptions.ListenAnyIP(5001, listenoptions =>
                        {
                            // certificate is an x509certificate2
                            listenoptions.UseHttps(_Certificate);
                        });
                    });
                });

        private static async Task CreateDbIfNotExists(IServiceProvider services)
        {
            try
            {
                var context = services.GetRequiredService<DatabaseContext>();
                await DatabaseInitializer.Initialize(context);
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred creating the DB.");
            }
        }

        private static async Task LoadPlugins(IServiceProvider services)
        {
            try
            {
                var context = services.GetRequiredService<PluginContext>();
                await context.InitializePlugins();
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred initializing plugins.");
            }
        }

        public void Shutdown()
        {
            throw new NotImplementedException();
        }
    }
}
