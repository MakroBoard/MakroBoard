import { ConfigParameter } from "./ConfigParameter";

export class View
{
  constructor(
    public viewType: string,
    public configParameters: Array<ConfigParameter>) { }
}
