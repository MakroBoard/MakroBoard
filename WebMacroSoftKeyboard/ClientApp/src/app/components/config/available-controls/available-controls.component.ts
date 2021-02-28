import { Component, OnInit } from '@angular/core';
import { Plugin } from '../../../Models/Controls';
import { DataService } from '../../../Services/data.service';

@Component({
  selector: 'app-available-controls',
  templateUrl: './available-controls.component.html',
  styleUrls: ['./available-controls.component.scss']
})
export class AvailableControlsComponent implements OnInit
{
  public plugins: Array<Plugin> = new Array<Plugin>();

  constructor(private dataService: DataService) { }

  ngOnInit(): void
  {
    this.dataService.getAvailableControls().then((plugins: Array<Plugin>) =>
    {
      this.plugins = plugins;
    });
  }
}
