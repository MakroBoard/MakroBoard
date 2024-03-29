﻿using MakroBoard.PluginContract;
using MakroBoard.PluginContract.Parameters;
using MakroBoard.PluginContract.Views;
using System;
using System.Timers;

namespace MakroBoard.Plugin.Clock
{
    public class ClockControl : Control
    {
        private readonly TextView _TextView;
        private Timer _Timer;

        public ClockControl()
        {
            _TextView = new TextView("Clock");
        }

        public override string SymbolicName => "Clock";

        public override View View => _TextView;

        protected override void Subscribe(ParameterValues configParameters)
        {
            if (_Timer == null)
            {
                _Timer = new Timer(1000);
                _Timer.Elapsed += (s, a) => OnControlChanged(new ParameterValues() { new StringParameterValue(_TextView.TextParameter, DateTime.Now.ToLongTimeString()) });
                _Timer.Start();
            }
        }
    }
}
