using MakroBoard.PluginContract.Parameters;
using System;

namespace MakroBoard.PluginContract
{
    public class PanelChangedEventArgs: EventArgs
    {
        public PanelChangedEventArgs(Control control, int panelId, ParameterValues parameterValues)
        {
            Control = control;
            PanelId = panelId;
            ParameterValues = parameterValues;
        }

        public Control Control { get; }
        public int PanelId { get; }
        public ParameterValues ParameterValues { get; }
    }
}
