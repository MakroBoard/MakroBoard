using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public abstract class MakroBoardPluginBase : IMakroBoardPlugin
    {
        protected MakroBoardPluginBase()
        {
        }

        public void Initialize(string pluginDirectory)
        {
            Controls = InitializeControls();
            PluginDirectory = pluginDirectory;
        }

        protected abstract IReadOnlyCollection<Control> InitializeControls();

        protected string PluginDirectory { get; private set; }

        public string SymbolicName => GetType().Name;

        public IReadOnlyCollection<Control> Controls { get; private set; }

        public abstract LocalizableString Title { get; }

        public virtual Image PluginIcon => null;

        public virtual async Task<Control> GetControl(string symbolicName)
        {
            var controls = await GetControls().ConfigureAwait(false);
            var control = controls.FirstOrDefault(x => x.SymbolicName.Equals(symbolicName, System.StringComparison.OrdinalIgnoreCase));

            return control;
        }

        public virtual Task<IEnumerable<Control>> GetControls()
        {
            return Task.FromResult<IEnumerable<Control>>(Controls);
        }

        public ImageData LoadImage(string imageName)
        {
            var imageDir = Path.Combine(PluginDirectory, "images");
            var image = Directory.EnumerateFiles(imageDir, $"{imageName}.*").FirstOrDefault();
            if (image != null)
            {
                return new ImageData(File.ReadAllBytes(image), Path.GetExtension(image));
            }

            return null;
        }
    }
}
