using System.Collections.Generic;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public interface IMakroBoardPlugin
    {
        string SymbolicName { get; }

        LocalizableString Title { get; }

        public string PluginIcon { get; }

        Task<IEnumerable<Control>> GetControls();

        Task<Control> GetControl(string symbolicName);

        void Initialize(string pluginDirectory);

        /// <summary>
        /// If the plugin needs any images they should be provided over this method
        /// </summary>
        /// <returns></returns>
        ImageData LoadImage(string imageName);
    }
}
