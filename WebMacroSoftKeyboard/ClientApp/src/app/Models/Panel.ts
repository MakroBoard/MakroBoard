import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

import { ConfigValue, ConfigValueAdapter } from "./ConfigValue";
import { Control, ControlAdapter } from "./Control";

export class Panel
{
  constructor(
    public control: Control,
    public viewConfigValues: Array<ConfigValue>,
    public configValues: Array<ConfigValue>)
  { }
}



@Injectable({
  providedIn: "root",
})
export class PanelAdapter implements Adapter<Panel>
{
  constructor(private controlAdapter: ControlAdapter, private configValueAdapter: ConfigValueAdapter)
  {

  }

  adapt(item: any): Panel
  {
    return new Panel(this.controlAdapter.adapt(item.control), item.viewConfigValues.map((cv: any) => this.configValueAdapter.adapt(cv)), item.configValues.map((cv: any) => this.configValueAdapter.adapt(cv)));
  }
}
