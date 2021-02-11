using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using System;
using WebMacroSoftKeyboard.Data;
using System.IO;
using System.Threading;
using WebMacroSoftKeyboard.UI;
using Avalonia;
using WebMacroSoftKeyboard.UI.Views;
using Avalonia.Controls;
using System.Threading.Tasks;

namespace WebMacroSoftKeyboard
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var dataDir = Constants.DataDirectory;
            Console.WriteLine($"Using Data Directory: {dataDir}");
            if (!Directory.Exists(dataDir))
            {
                Directory.CreateDirectory(dataDir);
            }

            //CreateHostBuilder(args).Build().Run();
            var host = CreateHostBuilder(args).Build();
            //new Host();

            CreateDbIfNotExists(host);


            Task.Run(() =>
            {
                var app = new App();
                AppBuilder.Configure(() => new App())
                    //_ = AppBuilder.Configure(app)
                    .UsePlatformDetect()
                    .SetupWithoutStarting();

                //var dialog = new MainWindow();
                //dialog.Show();
                app.RunWithMainWindow<MainWindow>();
            });

            host.Run();

            //var thread = new Thread(
            //delegate () //Use a delegate here instead of a new ThreadStart
            //{
            //    Thread.Sleep(1000);
            //    //example.StaRequired(); //Whatever you want to call with STA
            //})
            //{
            //    IsBackground = false,
            //    Priority = ThreadPriority.Normal
            //};

            //thread.SetApartmentState(ApartmentState.STA);
            //thread.Start(); //Start the thread
            //thread.Join(); //Block the calling thread

        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });

        private static void CreateDbIfNotExists(IHost host)
        {
            using var scope = host.Services.CreateScope();

            var services = scope.ServiceProvider;
            try
            {
                var context = services.GetRequiredService<ClientContext>();
                ClientInitializer.Initialize(context);
            }
            catch (Exception ex)
            {
                var logger = services.GetRequiredService<ILogger<Program>>();
                logger.LogError(ex, "An error occurred creating the DB.");
            }
        }
    }
}
