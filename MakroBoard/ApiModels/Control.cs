using System.Collections.Generic;

namespace MakroBoard.ApiModels
{
    public class Control
    {
        public Control(string symbolicName, View view, ConfigParameters configParameters, IEnumerable<Control> subControls)
        {
            SymbolicName = symbolicName;
            View = view;
            ConfigParameters = configParameters;
            SubControls = subControls;
        }

        public string SymbolicName { get; }

        public View View { get; }
        public ConfigParameters ConfigParameters { get; }

        public IEnumerable<Control> SubControls { get; }
    }
}
