import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";
import { Control, ControlAdapter } from "./Control";
import { IFilterable } from "./Filterable";


export class Plugin implements IFilterable
{
  constructor(
    public pluginName: string,
    public controls: Array<Control>) { }

  filter(filterText: string): boolean
  {
    let index = this.pluginName.toUpperCase().indexOf(filterText);
    return index >= 0;
  }
}

@Injectable({
  providedIn: "root",
})
export class PluginAdapter implements Adapter<Plugin>
{
  constructor(private controlAdapter: ControlAdapter)
  {

  }

  adapt(item: any): Plugin
  {
    return new Plugin(item.pluginName, item.controls.map((c: any) => this.controlAdapter.adapt(c)));
  }

}
