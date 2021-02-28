// app/core/course.model.ts
import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

export class Plugin
{
  constructor(
    public pluginName: string,
    public controls: Array<Control>)
  { }
}

export class Control
{
  constructor(
    public symbolicName: string,
    public view: View,
    public configParameters: Array<ConfigParameter>)
  { }
}

export class View
{
  constructor(
    public viewType: string)
  { }
}


export class ConfigParameter
{
  constructor(
    public symbolicName: string,
    public parameterType: string,
    public validationRegEx: string,
    public minValue: number,
    public maxValue: number)
  { }
}


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
    return new View(item.viewType);
  }

  adaptConfigParameter(item: any): ConfigParameter
  {
    return new ConfigParameter(item.symbolicName, item.parameterType, item.validationRegEx, item.minValue, item.maxValue);
  }
}
