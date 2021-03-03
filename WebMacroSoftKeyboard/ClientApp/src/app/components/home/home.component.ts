import { Component, OnInit } from '@angular/core';
import { Page } from '../../Models/Page';
import { Panel } from '../../Models/Panel';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit
{

  public pages: Array<Page> = new Array<Page>();

  constructor() { }

  ngOnInit(): void
  {
  }

  addNewPage()
  {
    this.pages.push(new Page("New Page " + (this.pages.length + 1), "web", new Array<Panel>()));
  }

}
