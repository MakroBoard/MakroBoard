import { Injectable } from "@angular/core";
import { Adapter } from "./Adapter";

import { Panel, PanelAdapter } from "./Panel";

export class Page
{
  constructor(
    public symbolicName: string,
    public label: string,
    public icon: string,
    public panels: Array<Panel>)
  { }
}

@Injectable({
  providedIn: "root",
})
export class PageAdapter implements Adapter<Page>
{
  constructor(private panelAdapter: PanelAdapter)
  {
  }

  adapt(item: any): Page
  {
    return new Page(item.symbolicName, item.label, item.icon, item.panels?.map((p: any) => this.panelAdapter.adapt(p)));
  }
}
