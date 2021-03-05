import { Component, Input, OnInit } from '@angular/core';
import { Panel } from '../../../Models/Panel';
import { DataService } from '../../../Services/data.service';

@Component({
  selector: 'app-button',
  templateUrl: './button.component.html',
  styleUrls: ['./button.component.scss']
})
export class ButtonComponent implements OnInit
{

  @Input()
  public panel!: Panel;

  constructor(private dataService: DataService) { }

  ngOnInit(): void
  {
  }

  execute(): void
  {
    this.dataService.executeControl(this.panel.control.symbolicName, this.panel.configValues);
  }
}
