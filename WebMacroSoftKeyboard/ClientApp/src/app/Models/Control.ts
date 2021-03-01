// app/core/course.model.ts
import { ConfigParameter } from "./ConfigParameter";
import { View } from "./View";

export class Control
{
  constructor(
    public symbolicName: string,
    public view: View,
    public configParameters: Array<ConfigParameter>)
  { }
}

