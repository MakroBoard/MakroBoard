import { Component, Input, OnInit } from '@angular/core';
import { Panel } from '../../../../Models/Panel';

@Component({
  selector: 'app-button',
  templateUrl: './button.component.html',
  styleUrls: ['./button.component.scss']
})
export class ButtonComponent implements OnInit
{

  @Input()
  public panel!: Panel;

  constructor() { }

  ngOnInit(): void
  {
  }

  execute(): void
  {
    alert(this.panel.control.symbolicName);
  }


}
