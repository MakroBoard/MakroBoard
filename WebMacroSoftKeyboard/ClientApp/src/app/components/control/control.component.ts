import { Component, Input, OnInit } from '@angular/core';
import { ConfigValue } from '../../Models/ConfigValue';
import { Control } from '../../Models/Control';
import { Panel } from '../../Models/Panel';

@Component({
  selector: 'app-control',
  templateUrl: './control.component.html',
  styleUrls: ['./control.component.scss']
})
export class ControlComponent implements OnInit
{


  private _control!: Control;

  @Input()
  get control(): Control { return this._control; }
  set control(control: Control)
  {
    this._control = control;
    this.viewConfigValues = this.control.view.configParameters.map(cp => new ConfigValue(cp.symbolicName, undefined))
    this.configValues = this.control.configParameters.map(cp => new ConfigValue(cp.symbolicName, undefined))
    this.panel = new Panel(this._control, this.viewConfigValues, this.configValues);
  }

  public viewConfigValues!: Array<ConfigValue>;
  public configValues!: Array<ConfigValue>;

  public panel!: Panel;

  constructor() { }

  ngOnInit(): void
  {
  }

}
