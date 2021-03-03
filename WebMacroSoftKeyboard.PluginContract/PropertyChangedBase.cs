using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace WebMacroSoftKeyboard.PluginContract
{
    public class PropertyChangedBase : INotifyPropertyChanged
    {
        protected PropertyChangedBase()
        {

        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
