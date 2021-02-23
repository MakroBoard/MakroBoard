using System;
using System.Diagnostics;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Routing;

namespace WebMacroSoftKeyboard.ActionFilters
{
public class LocalhostAttribute : ActionFilterAttribute
{
    public override void OnActionExecuting(ActionExecutingContext context)
    {
        var ip = context.HttpContext.Connection.RemoteIpAddress;
        if (!IPAddress.IsLoopback(ip)) {
            context.Result = new UnauthorizedResult();
            return;
        }
        base.OnActionExecuting(context);
    }
}
}



