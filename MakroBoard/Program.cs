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
using System.Diagnostics;
using System.Text.Json;
using System.Text.Json.Serialization;
using NLog;
using System.Globalization;

namespace MakroBoard
{
    public class Program
    {
        private const string _LocalHost = "https://localhost:";

        // NLog: setup the logger first to catch all errors :)
        private static readonly Logger _Logger = LogManager.Setup(c => c.LoadConfigurationFromFile("nlog.config")).GetCurrentClassLogger();
        private X509Certificate2 _Certificate;
        private Localsettings _Localsettings;
        private TrayIcon _TrayIcon;
        private IHost _Host;

        public static Task Main(string[] args)
        {
            var program = new Program();
            return program.Start(args);
        }

        private async Task Start(string[] args)
        {

            try
            {
                ShowTrayIcon();

                _Logger.Debug("init log");
                _Logger.Debug($"Using Data Directory: {Constants.DataDirectory}");
                InitializeDataDir();
                await InitializeInstanceSeed().ConfigureAwait(false);
                InitializeCertificate();
                InitializeConfig();

                using (_Host = CreateHostBuilder(args).Build())
                {
                    var scope = _Host.Services.CreateAsyncScope();
                    await using (scope.ConfigureAwait(false))
                    {
                        var services = scope.ServiceProvider;

                        await CreateDbIfNotExists(services).ConfigureAwait(false);
                        await LoadPlugins(services).ConfigureAwait(false);

                        _Logger.Info("Server Started");

                        await _Host.RunAsync().ConfigureAwait(false);
                    }
                }
            }
            catch (Exception ex)
            {
                //NLog: catch setup errors
                _Logger.Error(ex, "Stopped program because of exception");
                throw;
            }
            finally
            {
                // Ensure to flush and stop internal timers/threads before application-exit (Avoid segmentation fault on Linux)
                LogManager.Shutdown();
            }
        }

        private void ShowTrayIcon()
        {
            var thread = new Thread(() =>
            {
                _TrayIcon = new TrayIcon();
                _TrayIcon.Show(new TrayMenu(new List<ITrayMenuItem>
                {
                    new TrayMenuItem("MakroBoard öffnen", i =>
                    {
                        Process.Start(new ProcessStartInfo(string.Create(CultureInfo.InvariantCulture,$"{_LocalHost}{_Localsettings.Port}"))
                        {
                            UseShellExecute = true,
                        });

                    }),
                    new TrayMenuItem("Beenden", async i =>
                    {
                        _TrayIcon.Remove();
                        if(_Host != null)
                        {
                            await _Host.StopAsync().ConfigureAwait(false);
                        }
                    }),
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
                Constants.Seed = await File.ReadAllTextAsync(Constants.SeedFileName).ConfigureAwait(false);
            }
            else
            {
                Constants.Seed = Encoding.UTF8.GetString(SHA512.HashData(Encoding.UTF8.GetBytes(string.Create(CultureInfo.InvariantCulture, $"WMSK_{DateTime.Now:O}{new Random().Next()}"))));
                await File.WriteAllTextAsync(Constants.SeedFileName, Constants.Seed).ConfigureAwait(false);
            }
        }

        private static void InitializeDataDir()
        {
            if (!Directory.Exists(Constants.DataDirectory))
            {
                Directory.CreateDirectory(Constants.DataDirectory);
            }
        }

        private void InitializeConfig()
        {
            try
            {
                if (!File.Exists(Constants.LocalSettingsFileName))
                {
                    _Localsettings = new Localsettings();
                    File.WriteAllText(Constants.LocalSettingsFileName, JsonSerializer.Serialize(_Localsettings));
                }
                else
                {
                    _Localsettings = JsonSerializer.Deserialize<Localsettings>(File.ReadAllText(Constants.LocalSettingsFileName));

                    if (!_Localsettings.Validatesettings())
                    {
                        _Logger.Info("localsettings are not valid, starting with default config!");
                        _Localsettings = new Localsettings();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error(ex, "An error occurred creating or reading the the localsettings file. starting with default config!");
                _Localsettings = new Localsettings();
            }
        }

        private void InitializeCertificate()
        {
            var cert = Certificates.LoadCertificate("MakroBoard");
            if (cert == null)
            {
                cert = Certificates.GenerateCertificate("MakroBoard");
                Certificates.SaveCertificate(cert);
            }

            _Certificate = cert;
        }

        public IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>()
                    .ConfigureLogging(logging =>
                    {
                        logging.ClearProviders();
                        logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
                    })
                    .UseNLog()
                    .UseUrls()
                    .UseKestrel(serverOptions =>
                    {
                        serverOptions.ListenAnyIP(_Localsettings.Port, listenoptions =>
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
                await DatabaseInitializer.Initialize(context).ConfigureAwait(false);
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
                await context.InitializePlugins().ConfigureAwait(false);
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred initializing plugins.");
            }
        }


    }
}
