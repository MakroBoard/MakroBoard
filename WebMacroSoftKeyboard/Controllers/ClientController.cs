using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WebMacroSoftKeyboard.Data;
using WebMacroSoftKeyboard.Models;

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

        // GET: api/RequestToken
        [HttpGet("requesttoken")]
        public async Task<ActionResult> GetRequestToken()
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress;
            var token = new Random().Next(10000, 99999);

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

        // GET: api/RequestToken
        [HttpGet("{token}")]
        public async Task<ActionResult<string>> GetSubmitToken(long token)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();
            var client = await _Context.Clients.FirstOrDefaultAsync(c => c.ClientIp.Equals(clientIp, StringComparison.OrdinalIgnoreCase));

            if (client == null)
            {
                return NotFound();
            }

            client.Token = Guid.NewGuid().ToString();
            await _Context.SaveChangesAsync();

            return client.Token;
        }
    }
}
