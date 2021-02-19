using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Data;
using WebMacroSoftKeyboard.HubConfig;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace WebMacroSoftKeyboard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClientController : ControllerBase
    {
        private readonly ClientContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ClientController(ClientContext context, IHubContext<ClientHub> clientHub)
        {
            _Context = context;
            _ClientHub = clientHub;
        }

        // GET: api/client/requesttokens
        [HttpGet("requesttokens")]
        public async Task<ActionResult<Client[]>> GetRequestTokens()
        {
            var currentTime = DateTime.Now;
            var currentClients = await _Context.Clients.Where(x => x.State == ClientState.None && x.ValidUntil < currentTime).ToArrayAsync();
            return Ok(currentClients);
            //var clientIp = Request.HttpContext.Connection.RemoteIpAddress;
            //var token = new Random().Next(10000, 99999);

            //var client = new Client
            //{
            //    Code = token,
            //    ClientIp = clientIp.ToString(),
            //};

            //Console.WriteLine($"RequestToken: {client.ClientIp} - {client.Code}");

            //await _Context.Clients.AddAsync(client);
            //await _Context.SaveChangesAsync();

            //return Ok();
        }

        /// <summary>
        /// GET: api/client/submittoken?code=12345
        //[HttpGet("submittoken")]
        [HttpPost("submitcode")]
        public async Task<ActionResult<DateTime>> PostSubmitCode([FromBody] int code)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp));
            if (client != null)
            {
                client.Code = code;
                client.ValidUntil = DateTime.UtcNow.AddMinutes(5);
                client.State = ClientState.None;

                _Context.Clients.Update(client);

                Console.WriteLine($"Update existing Client: {client.ClientIp} - {client.Code}");
            }
            else
            {
                client = new Client
                {
                    Code = code,
                    ValidUntil = DateTime.UtcNow.AddMinutes(5),
                    ClientIp = clientIp,
                };
                await _Context.Clients.AddAsync(client);

                Console.WriteLine($"Add new Client: {client.ClientIp} - {client.Code}");
            }

            await _Context.SaveChangesAsync();

            // TODO Groups
            await _ClientHub.Clients./*Group("adminClients")*/All.SendAsync("AddSubmitCode", client);

            return Ok(client.ValidUntil);
        }
    }
}
