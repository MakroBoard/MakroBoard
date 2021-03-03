import { Control } from "./Control";
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
