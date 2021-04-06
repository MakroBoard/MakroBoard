using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.ActionFilters;
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
        private readonly ILogger<ClientController> _logger;
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ClientController(ILogger<ClientController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub)
        {
            _logger = logger;
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

        [HttpGet("checktoken")]
        public async Task<ActionResult<bool>> GetCheckToken([FromHeader] string authorization)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp) && x.Token.Equals(authorization));
            var result = client != null && client.State == ClientState.Confirmed;
            return Ok(result);
        }



        /// <summary>
        /// GET: api/client/submittoken
        //[HttpGet("submittoken")]
        [HttpPost("submitcode")]
        public async Task<ActionResult<DateTime>> PostSubmitCode([FromBody] int code)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp));
            if (client != null)
            {
                client.Code = code;
                client.ValidUntil = DateTime.UtcNow.AddMinutes(0.5);
                client.State = ClientState.None;

                _Context.Clients.Update(client);

                _logger.LogDebug($"Update existing Client: {client.ClientIp} - {client.Code}");
            }
            else
            {
                client = new Data.Client
                {
                    Code = code,
                    ValidUntil = DateTime.UtcNow.AddMinutes(5),
                    ClientIp = clientIp,
                };
                await _Context.Clients.AddAsync(client);

                 _logger.LogDebug($"Add new Client: {client.ClientIp} - {client.Code}");
            }

            await _Context.SaveChangesAsync();

            // TODO Groups
            await _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, client);

            return Ok(client.ValidUntil);
        }

        /// <summary>
        /// POST: api/client/confirmclient
        /// </summary>
        [HttpPost("confirmclient")]
        [LocalHost]
        public async Task<ActionResult> PostConfirmClient([FromBody] ApiModels.Client client)
        {
            var currentClient = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(client.ClientIp) && x.Code.Equals(client.Code));
            if (currentClient == null)
            {
                return BadRequest("No suitable client found.");
            }

            byte[] bytes = SHA512.Create().ComputeHash(Encoding.UTF8.GetBytes($"WMSK_{client.ClientIp}{client.Code}{DateTime.Now:O}{Constants.Seed}{new Random().Next()}"));

            var token = Convert.ToBase64String(bytes);
            currentClient.Token = token;
            currentClient.State = ClientState.Confirmed;
            client.State = (int)ClientState.Confirmed;

            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Confirm Client: {currentClient.ClientIp} - {currentClient.Code}");

            await _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, currentClient);

            var targetClients = (await _Context.Sessions.Where(x => x.Client.ClientIp.Equals(client.ClientIp)).ToListAsync()).Select(x => x.ClientSignalrId);
            await _ClientHub.Clients.Clients(targetClients).SendAsync(ClientMethods.AddOrUpdateToken, token);

            return Ok();
        }

        /// <summary>
        /// GET: api/client/confirmclient
        [HttpPost("removeClient")]
        [LocalHost]
        public async Task<ActionResult> PostRemoveClient([FromBody] ApiModels.Client client)
        {
            var currentClient = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(client.ClientIp) && x.Code.Equals(client.Code));
            if (currentClient == null)
            {
                return BadRequest("No suitable client found.");
            }

            _Context.Clients.Remove(currentClient);
            await _Context.SaveChangesAsync();

            _logger.LogDebug($"Remove Client: {currentClient.ClientIp} - {currentClient.Code}");

            await _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.RemoveClient, client);

            var targetClients = (await _Context.Sessions.Where(x => x.Client.ClientIp.Equals(client.ClientIp)).ToListAsync()).Select(x => x.ClientSignalrId);
            await _ClientHub.Clients.Clients(targetClients).SendAsync(ClientMethods.AddOrUpdateToken, string.Empty);

            return Ok();
        }

    }
}
