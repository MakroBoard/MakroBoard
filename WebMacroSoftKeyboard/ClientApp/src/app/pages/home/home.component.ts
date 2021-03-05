import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Page } from '../../Models/Page';
import { Panel } from '../../Models/Panel';
import { DataService } from '../../Services/data.service';
import { AddPageComponent } from '../../components/add-page/add-page.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit
{

  public pages: Array<Page> = new Array<Page>();

  constructor(public dialog: MatDialog, private dataService: DataService)
  {
   
  }

  ngOnInit(): void
  {
    this.dataService.onPageAddOrUpdate().subscribe({
      next: page =>
      {
        this.pages.push(page);
      }
    });
  }

  addNewPage()
  {
    const dialogRef = this.dialog.open(AddPageComponent);

    dialogRef.afterClosed().subscribe(result =>
    {
      this.dataService.addNewPage(dialogRef.componentInstance.label, dialogRef.componentInstance.icon);

      console.log(`Dialog result: ${result}`);
    });
    //this.pages.push(new Page("New Page " + (this.pages.length + 1), "web", new Array<Panel>()));
  }

}
