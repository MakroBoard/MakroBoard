﻿using MakroBoard.Plugin.Clock;
using MakroBoard.PluginContract;
using System.Collections.Generic;

namespace MakroBoard.Plugin.MultiMedia
{
    public class MultiMediaPlugin : MakroBoardPluginBase
    {
        private List<Control>? _Controls;

        public override LocalizableString Title => new(Resource.ResourceManager, nameof(Resource.Title));

        public override Image PluginIcon { get; } = new Image("multimedia", ImageType.Svg);

        protected override IReadOnlyCollection<Control> InitializeControls()
        {
            _Controls ??= new List<Control>
                {
                    new SystemAudioControl(),
                };

            return _Controls;
        }
    }
}
