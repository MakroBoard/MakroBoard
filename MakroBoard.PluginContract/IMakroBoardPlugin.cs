﻿using System.Collections.Generic;
using System.Threading.Tasks;

namespace MakroBoard.PluginContract
{
    public interface IMakroBoardPlugin
    {
        string SymbolicName { get; }

        LocalizableString Title { get; }

        Task<IEnumerable<Control>> GetControls();

        Task<Control> GetControl(string symbolicName);
        void Initialize();
    }
}
