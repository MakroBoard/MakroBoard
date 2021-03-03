// app/core/course.model.ts
import { Panel } from "./Panel";

export class Page
{
  constructor(
    public label: string,
    public icon: string,
    public panels: Array<Panel>)
  { }
}
