using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Data;

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

        public ClientController(ClientContext context)
        {
            _Context = context;
        }

        // GET: api/lastrequesttoken
        [HttpGet("lastrequesttoken")]
        public async Task<ActionResult<Client>> GetLastRequestToken()
        {
            var lastClient = await _Context.Clients.LastAsync();
            return lastClient;
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

        // GET: api/RequestToken
        [HttpGet("submittoken/{token}")]
        public async Task<ActionResult> GetSubmitToken(int token)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress;

            var client = new Client
            {
                Code = token,
                ClientIp = clientIp.ToString(),
            };

            Console.WriteLine($"RequestToken: {client.ClientIp} - {client.Code}");

            await _Context.Clients.AddAsync(client);
            await _Context.SaveChangesAsync();

            return Ok();
        }
    }
}
