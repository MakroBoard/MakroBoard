import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";
import { ConfigParameter, ConfigParameterAdapter } from "./ConfigParameter";

export class View
{
  constructor(
    public viewType: string,
    public configParameters: Array<ConfigParameter>) { }
}

@Injectable({
  providedIn: "root",
})
export class ViewAdapter implements Adapter<View>
{
  constructor(private configParameterAdapter: ConfigParameterAdapter)
  {

  }

  adapt(item: any): View
  {
    return new View(item.viewType, item.configParameters.map((cp: any) => this.configParameterAdapter.adapt(cp)));
  }
}
