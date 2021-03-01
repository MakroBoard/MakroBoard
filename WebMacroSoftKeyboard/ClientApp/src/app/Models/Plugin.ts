import { Control } from "./Control";


export class Plugin
{
  constructor(
    public pluginName: string,
    public controls: Array<Control>) { }
}
