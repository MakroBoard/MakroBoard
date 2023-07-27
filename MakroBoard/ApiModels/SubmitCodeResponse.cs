using System;

namespace MakroBoard.ApiModels
{
    public class SubmitCodeResponse : Response
    {
        public SubmitCodeResponse(DateTime validUntil)
        {
            ValidUntil = validUntil;
        }

        public DateTime ValidUntil { get; }
    }
}
