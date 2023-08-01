using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.IO;
using MakroBoard.Data;
using MakroBoard.HubConfig;
using MakroBoard.Plugin;
using MakroBoard.ActionFilters;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Threading;
using System;
using System.Net.Sockets;
using System.Text;
using System.Net;

namespace MakroBoard
{
    public class Startup
    {
        private readonly IWebHostEnvironment _Env;

        public Startup(IConfiguration _, IWebHostEnvironment env)
        {
            _Env = env;
        }


        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy", builder => builder
                //.WithOrigins("http://localhost:4200", "*")
                .AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader()
                //.AllowCredentials()
                );
            });

            var sqliteConnectionString = $"Filename={Constants.DatabaseFileName}";
            services.AddDbContext<DatabaseContext>(options => options.UseSqlite(sqliteConnectionString));


            if (_Env.IsDevelopment())
            {
                services.AddDatabaseDeveloperPageExceptionFilter();
            }

            services.AddScoped<AuthenticatedClientAttribute>();
            services.AddScoped<AuthenticatedAdminAttribute>();
            services.AddSingleton<PluginContext>();
            services.AddSignalR(o => { o.EnableDetailedErrors = _Env.IsDevelopment(); });
            services.AddControllersWithViews();

            // In production, the Angular files will be served from this directory
            services.AddSpaStaticFiles(configuration =>
            {
                configuration.RootPath = "wwwroot";
            });

            services.AddHostedService<ConnectBroadcastService>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public static void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");

                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            if (!env.IsDevelopment())
            {
                app.UseSpaStaticFiles();
            }

            app.UseRouting();
            app.UseCors("CorsPolicy");

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller}/{action=Index}/{id?}");

                endpoints.MapHub<ClientHub>("/hub/clients");
            });

            app.UseSpa(spa =>
            {
                // To learn more about options for serving an Angular SPA from ASP.NET Core,
                // see https://go.microsoft.com/fwlink/?linkid=864501

                spa.Options.SourcePath = "wwwroot";

                if (env.IsDevelopment())
                {
                    spa.UseProxyToSpaDevelopmentServer("http://localhost:4200");
                }
            });
        }
    }

    internal class ConnectBroadcastService : IHostedService, IDisposable
    {
        private const int _Port = 9876;
        private readonly ILogger<ConnectBroadcastService> _Logger;
        private Timer _Timer = null;
        private UdpClient _UdpClient = null;

        public ConnectBroadcastService(ILogger<ConnectBroadcastService> logger)
        {
            _Logger = logger;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _Logger.LogInformation("Timed Hosted Service running.");

            _UdpClient?.Dispose();
            _UdpClient = new UdpClient();
            _Timer = new Timer(DoWork, null, TimeSpan.Zero, TimeSpan.FromSeconds(5));

            return Task.CompletedTask;
        }

        private void DoWork(object state)
        {
            var hostName = Dns.GetHostName();

            // TODO get Port
            var data = Encoding.UTF8.GetBytes($@"makroboard:https:\\{hostName}:5001");
            _UdpClient.Send(data, data.Length, "255.255.255.255", _Port);
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _Logger.LogInformation("Timed Hosted Service is stopping.");
            _Timer?.Change(Timeout.Infinite, 0);
            return Task.CompletedTask;
        }

        public void Dispose()
        {
            _Timer?.Dispose();
            _UdpClient?.Dispose();
        }
    }
}
