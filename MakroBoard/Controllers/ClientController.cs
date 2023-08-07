using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;
using MakroBoard.ActionFilters;
using MakroBoard.Data;
using MakroBoard.HubConfig;
using MakroBoard.ApiModels;
using System.Threading;
using MakroBoard.Extensions;

// QR Code auf Localhost
// auf Handy -> Code anzeigen
// auf Rechner -> Code anzeigen und bestätigen

namespace MakroBoard.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ClientController : ControllerBase
    {
        private readonly ILogger<ClientController> _Logger;
        private readonly DatabaseContext _Context;
        private readonly IHubContext<ClientHub> _ClientHub;

        public ClientController(ILogger<ClientController> logger, DatabaseContext context, IHubContext<ClientHub> clientHub)
        {
            _Logger = logger;
            _Context = context;
            _ClientHub = clientHub;
        }

        // GET: api/client/requesttokens
        [HttpGet("requesttokens")]
        public async Task<ActionResult<RequestTokensResponse>> GetRequestTokens(CancellationToken cancellationToken)
        {
            var currentTime = DateTime.Now;
            var currentClients = await _Context.Clients.Where(x => x.State == ClientState.None && x.ValidUntil < currentTime).ToArrayAsync(cancellationToken);
            var result = currentClients.Select(ApiModels.Client.FromDataClient).ToArray();
            return Ok(new RequestTokensResponse(result));
        }

        [HttpGet("checktoken")]
        [ServiceFilter(typeof(AuthenticatedClientAttribute))]
        public async Task<ActionResult<CheckTokenResponse>> GetCheckToken([FromHeader] string authorization, CancellationToken cancellationToken)
        {
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();

            var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp), cancellationToken).ConfigureAwait(false);

            var result = false;
            if (client != null)
            {
                if (client.Token.Equals(authorization, StringComparison.Ordinal))
                {
                    result = client.State >= ClientState.Confirmed;
                }
                else
                {
                    await PostRemoveClient(new RemoveClientRequest { Client = new ApiModels.Client { ClientIp = client.ClientIp } }, cancellationToken).ConfigureAwait(false);
                }
            }
            return Ok(new CheckTokenResponse(result));
        }

        /// <summary>
        /// GET: api/client/submittoken
        //[HttpGet("submittoken")]
        [HttpPost("submitcode")]
        public async Task<ActionResult<DateTime>> PostSubmitCode([FromBody] SubmitCodeRequest request, CancellationToken cancellationToken)
        {
            var isLocalHost = Request.HttpContext.Connection.RemoteIpAddress.IsLocalHost();
            var clientIp = Request.HttpContext.Connection.RemoteIpAddress.ToString();


            var client = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(clientIp), cancellationToken).ConfigureAwait(false);
            if (client != null)
            {
                client.Code = request.Code;
                client.ValidUntil = DateTime.UtcNow.AddMinutes(0.5);
                client.State = isLocalHost ? ClientState.Admin : ClientState.None;

                _Context.Clients.Update(client);

                _Logger.LogDebug("Update existing Client: {ClientIp} - {Code}", client.ClientIp, client.Code);
            }
            else
            {
                client = new Data.Client
                {
                    Code = request.Code,
                    ValidUntil = DateTime.UtcNow.AddMinutes(5),
                    ClientIp = clientIp,
                    State = isLocalHost ? ClientState.Admin : ClientState.None,
                };

                if (isLocalHost)
                {
                    client.CreateNewToken(Constants.Seed);
                }

                await _Context.Clients.AddAsync(client, cancellationToken);

                _Logger.LogDebug("Add new Client: {ClientIp} - {Code}", client.ClientIp, client.Code);
            }

            await _Context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            // TODO Groups
            _ = _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, client, cancellationToken);

            if (isLocalHost)
            {
                await SendToken(ApiModels.Client.FromDataClient(client), cancellationToken).ConfigureAwait(false);
            }

            return Ok(new SubmitCodeResponse(client.ValidUntil));
        }

        private async Task SendToken(ApiModels.Client client, CancellationToken cancellationToken)
        {
            var targetClients = (await _Context.Sessions.Where(x => x.Client.ClientIp.Equals(client.ClientIp)).ToListAsync(cancellationToken).ConfigureAwait(false)).Select(x => x.ClientSignalrId);
            _ = _ClientHub.Clients.Clients(targetClients).SendAsync(ClientMethods.AddOrUpdateToken, client.Token, cancellationToken);
        }

        /// <summary>
        /// POST: api/client/confirmclient
        /// </summary>
        [HttpPost("confirmclient")]
        [ServiceFilter(typeof(AuthenticatedAdminAttribute))]
        public async Task<ActionResult> PostConfirmClient([FromBody] ConfirmClientRequest request, CancellationToken cancellationToken)
        {
            var currentClient = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(request.Client.ClientIp) && x.Code.Equals(request.Client.Code), cancellationToken).ConfigureAwait(false);
            if (currentClient == null)
            {
                return BadRequest("No suitable client found.");
            }

            currentClient.CreateNewToken(Constants.Seed);
            currentClient.State = ClientState.Confirmed;

            await _Context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            _Logger.LogDebug("Confirm Client: {ClientIp} - {Code}", currentClient.ClientIp, currentClient.Code);

            _ = _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.AddOrUpdateClient, currentClient, cancellationToken);

            await SendToken(ApiModels.Client.FromDataClient(currentClient), cancellationToken).ConfigureAwait(false);


            return Ok(new ConfirmClientResponse());
        }

        /// <summary>
        /// GET: api/client/confirmclient
        [HttpPost("removeClient")]
        [ServiceFilter(typeof(AuthenticatedAdminAttribute))]
        public async Task<ActionResult> PostRemoveClient([FromBody] RemoveClientRequest request, CancellationToken cancellationToken)
        {
            var currentClient = await _Context.Clients.FirstOrDefaultAsync(x => x.ClientIp.Equals(request.Client.ClientIp), cancellationToken).ConfigureAwait(false);
            if (currentClient == null)
            {
                return BadRequest(new RemoveClientResponse { Status = ResponseStatus.Error, Error = "No suitable client found." });
            }

            if (Request.HttpContext.Connection.RemoteIpAddress.ToString().Equals(currentClient.ClientIp, StringComparison.Ordinal))
            {
                _Logger.LogWarning("Client can not delete him self.");
                return Conflict(new RemoveClientResponse { Status = ResponseStatus.Error, Error = "Client can not delete him self." });
            }

            _Context.Clients.Remove(currentClient);
            await _Context.SaveChangesAsync(cancellationToken).ConfigureAwait(false);

            _Logger.LogDebug("Remove Client: {ClientIp} - {Code}", currentClient.ClientIp, currentClient.Code);

            var targetClients = (await _Context.Sessions.Where(x => x.Client.ClientIp.Equals(request.Client.ClientIp)).ToListAsync(cancellationToken).ConfigureAwait(false)).Select(x => x.ClientSignalrId);
            _ = _ClientHub.Clients.Clients(targetClients).SendAsync(ClientMethods.AddOrUpdateToken, string.Empty, cancellationToken);

            _ = _ClientHub.Clients.Group(ClientGroups.AdminGroup).SendAsync(ClientMethods.RemoveClient, request.Client, cancellationToken);


            return Ok(new RemoveClientResponse());
        }
    }
}
