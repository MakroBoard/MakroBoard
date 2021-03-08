import { Component, OnDestroy, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { NgxMasonryOptions } from 'ngx-masonry';
import { AddPanelComponent } from '../../components/add-panel/add-panel.component';
import { Panel } from '../../Models/Panel';
import { DataService } from '../../Services/data.service';

@Component({
  selector: 'app-page',
  templateUrl: './page.component.html',
  styleUrls: ['./page.component.scss']
})
export class PageComponent implements OnInit, OnDestroy 
{
  private sub: any;
  private name!: string;

  public masonryOptions: NgxMasonryOptions = {
    gutter: 10
  };

  public panels: Array<Panel> = new Array<Panel>();

  constructor(public dialog: MatDialog, private dataService: DataService, private route: ActivatedRoute)
  {

  }

  ngOnInit(): void
  {
    this.sub = this.route.params.subscribe(params =>
    {
      this.name = params['name'];

      //this.dataService.onPanelAddOrUpdate(this.name).subscribe({
      //  next: panel =>
      //  {
      //    this.panels.push(panel);
      //  }
      //});
    });
  }



  ngOnDestroy()
  {
    this.sub.unsubscribe();
  }



  addNewPanel()
  {
    const dialogRef = this.dialog.open(AddPanelComponent);

    dialogRef.afterClosed().subscribe(result =>
    {
      if (result === true)
      {
        //this.dataService.addNewPanel(dialogRef.componentInstance.label, dialogRef.componentInstance.icon);
      }
    });
    //this.pages.push(new Page("New Page " + (this.pages.length + 1), "web", new Array<Panel>()));
  }
}
