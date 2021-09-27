using System.Collections.Generic;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System.Linq;
using System;

namespace MakroBoard.PluginContract
{
    public class ListControl : Control
    {

        public ListControl(string symbolicName, IReadOnlyList<Control> subControls)
        {
            SymbolicName = symbolicName;
            SubControls = subControls;
            View = new ListView(SymbolicName, SubControls.Select(x => x.View).ToList());
            foreach (var configParameter in SubControls.SelectMany(x => x.ConfigParameters))
            {
                AddConfigParameter(configParameter);
            }
        }

        public override string SymbolicName { get; }

        public override View View { get; }

        public IReadOnlyList<Control> SubControls { get; }


        internal override void InternalSubscribe(ParameterValues configParameters, int panelId, Action<PanelChangedEventArgs> onControlChanged)
        {
            base.InternalSubscribe(configParameters, panelId, onControlChanged);
            foreach (var control in SubControls)
            {
                control.Subscribe(configParameters, panelId, onControlChanged);
            }
        }
    }
}
