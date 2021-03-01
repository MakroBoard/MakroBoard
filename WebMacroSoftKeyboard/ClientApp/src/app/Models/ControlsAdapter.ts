import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";
import { ConfigParameter } from "./ConfigParameter";
import { Plugin } from "./Plugin";
import { View } from "./View";
import { Control } from "./Control";


@Injectable({
  providedIn: "root",
})
export class ControlsAdapter implements Adapter<Plugin>
{
  adapt(item: any): Plugin
  {
    return new Plugin(item.pluginName, item.controls.map((c: any) => this.adaptControl(c)));
  }

  adaptControl(item: any): Control
  {
    return new Control(item.symbolicName, this.adaptView(item.view), item.configParameters.map((cp: any) => this.adaptConfigParameter(cp)));
  }

  adaptView(item: any): View
  {
    return new View(item.viewType, item.configParameters.map((cp: any) => this.adaptConfigParameter(cp)));
  }

  adaptConfigParameter(item: any): ConfigParameter
  {
    return new ConfigParameter(item.symbolicName, item.parameterType, item.validationRegEx, item.minValue, item.maxValue);
  }
}
