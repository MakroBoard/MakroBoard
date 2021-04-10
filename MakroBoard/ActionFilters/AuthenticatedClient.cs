using System.Linq;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using MakroBoard.Data;

namespace MakroBoard.ActionFilters
{
    public class AuthenticatedClientAttribute : ActionFilterAttribute
    {
        private DatabaseContext _Context;

        public AuthenticatedClientAttribute(DatabaseContext context)
        {
            _Context = context;
        }
        public async override void OnActionExecuting(ActionExecutingContext context)
        {
            context.Result = new UnauthorizedResult();

            if (context.HttpContext.Request.Headers.TryGetValue("authorization", out var token))
            {
                var client = await _Context.Clients.FirstOrDefaultAsync(c => c.State == ClientState.Confirmed && c.Token != null && c.Token.Equals(token, System.StringComparison.Ordinal));
                if (client != null)
                {
                    base.OnActionExecuting(context);
                }
            }

        }
    }
}