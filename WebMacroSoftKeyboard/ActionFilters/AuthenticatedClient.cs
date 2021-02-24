using System.Linq;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using WebMacroSoftKeyboard.Data;

namespace WebMacroSoftKeyboard.ActionFilters
{
    public class AuthenticatedClientAttribute : ActionFilterAttribute
    {
        private ClientContext _Context;

        public AuthenticatedClientAttribute(ClientContext context)
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



