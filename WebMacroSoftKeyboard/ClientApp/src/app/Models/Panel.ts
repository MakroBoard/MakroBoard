// app/core/course.model.ts
import { ConfigValue } from "./ConfigValue";
import { Control } from "./Control";

export class Panel
{
  constructor(
    public control: Control,
    public viewConfigValues: Array<ConfigValue>,
    public configValues: Array<ConfigValue>)
  { }
}
