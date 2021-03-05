import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

export class ConfigParameter
{
  constructor(
    public symbolicName: string,
    public parameterType: string,
    public validationRegEx: string,
    public minValue: number,
    public maxValue: number) { }
}


@Injectable({
  providedIn: "root",
})
export class ConfigParameterAdapter implements Adapter<ConfigParameter>
{

  adapt(item: any): ConfigParameter
  {
    return new ConfigParameter(item.symbolicName,
      item.parameterType,
      item.validationRegEx,
      item.minValue,
      item.maxValue);
  }
}
