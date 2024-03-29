﻿using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.Clock
{
    public sealed class ClockPlugin : MakroBoardPluginBase
    {
        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("clock-outline", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            return new List<Control>
            {
                new ClockControl(),
            };
        }
    }
}
