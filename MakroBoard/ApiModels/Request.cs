using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MakroBoard.ApiModels
{
    public class Request
    {

    }

    public class Response
    {
        public ResponseStatus Status { get; set; }

        public string Error { get; set; }
    }

    public enum ResponseStatus
    {
        Ok,
        Error
    }

    public class RequestTokensResponse : Response
    {
        public RequestTokensResponse(Client[] clients)
        {
            Clients = clients;
        }

        public Client[] Clients { get; }
    }

    public class CheckTokenResponse : Response
    {
        public CheckTokenResponse(bool isValid)
        {
            IsValid = isValid;
        }

        public bool IsValid { get; }
    }

    public class SubmitCodeRequest : Request
    {
        public SubmitCodeRequest(int code)
        {
            Code = code;
        }

        public int Code { get; }
    }

    public class SubmitCodeResponse : Response
    {
        public SubmitCodeResponse(DateTime validUntil)
        {
            ValidUntil = validUntil;
        }

        public DateTime ValidUntil { get; }
    }

    public class ConfirmClientRequest : Request
    {
        public Client Client { get; set; }
    }

    public class ConfirmClientResponse : Response
    {

    }

    public class RemoveClientRequest : Request
    {

        public Client Client { get; set; }
    }

    public class RemoveClientResponse : Response
    {

    }

    public class AvailableControlsResponse : Response
    {
        public AvailableControlsResponse(List<Plugin> plugins)
        {
            Plugins = plugins;
        }

        public List<Plugin> Plugins { get; }
    }

    public class ExecuteRequest : Request
    {
        public string SymbolicName { get; set; }

        public ConfigValues ConfigValues { get; set; }
    }

    public class ExecuteResponse : Response
    {
        public ExecuteResponse(string result)
        {
            Result = result;
        }

        public string Result { get; }
    }

    public class AddPageRequest : Request
    {
        public Page Page { get; set; }
    }

    public class AddPageResponse : Response
    {

    }

    public class AddGroupRequest : Request
    {
        public Group Group { get; set; }
    }

    public class AddGroupResponse : Response
    {

    }

    public class EditGroupRequest : Request
    {
        public Group Group { get; set; }
    }

    public class EditGroupResponse : Response
    {

    }

    public class RemoveGroupRequest : Request
    {
        public int GroupId { get; set; }
    }

    public class RemoveGroupResponse : Response
    {

    }

    public class AddPanelRequest : Request
    {
        public Panel Panel { get; set; }
    }

    public class AddPanelResponse : Response
    {

    }
}
