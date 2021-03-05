import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

export class ConfigValue
{
  constructor(
    public symbolicName: string,
    public value: any) { }
}


@Injectable({
  providedIn: "root",
})
export class ConfigValueAdapter implements Adapter<ConfigValue>
{
  adapt(item: any): ConfigValue
  {
    return new ConfigValue(item.symbolicName, item.value);
  }
}
