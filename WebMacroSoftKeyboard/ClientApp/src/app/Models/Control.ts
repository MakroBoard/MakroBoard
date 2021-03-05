import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

import { ConfigParameter, ConfigParameterAdapter } from "./ConfigParameter";
import { View, ViewAdapter } from "./View";

export class Control
{
  constructor(
    public symbolicName: string,
    public view: View,
    public configParameters: Array<ConfigParameter>)
  { }
}

@Injectable({
  providedIn: "root",
})
export class ControlAdapter implements Adapter<Control>
{
  constructor(private viewAdapter: ViewAdapter, private configParameterAdapter: ConfigParameterAdapter)
  {

  }

  adapt(item: any): Control
  {
    return new Control(item.symbolicName, this.viewAdapter.adapt(item.view), item.configParameters.map((cp: any) => this.configParameterAdapter.adapt(cp)));
  }
}
