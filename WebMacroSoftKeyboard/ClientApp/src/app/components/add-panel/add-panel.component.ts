import { Component, OnInit } from '@angular/core';
import { Plugin } from '../../Models/Plugin';
import { DataService } from '../../Services/data.service';

@Component({
  selector: 'app-add-panel',
  templateUrl: './add-panel.component.html',
  styleUrls: ['./add-panel.component.scss']
})
export class AddPanelComponent implements OnInit {

  public plugins: Array<Plugin> = new Array<Plugin>();
  public searchText: string = '';

  constructor(private dataService: DataService) { }

  ngOnInit(): void
  {
    this.dataService.getAvailableControls().then((plugins: Array<Plugin>) =>
    {
      this.plugins = plugins;
    });
  }

}
