﻿using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.SystemInfo
{
    public sealed class SystemInfoPlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("information-variant-box-outline", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            var memoryControl = new MemoryControl();
            var cpuControl = new ProcessCpuControl();
            return new List<Control>
            {
                memoryControl,
                cpuControl,
                new ListControl("SystemInfo", new Control[]{memoryControl, cpuControl} ),
            };
        }
    }
}
