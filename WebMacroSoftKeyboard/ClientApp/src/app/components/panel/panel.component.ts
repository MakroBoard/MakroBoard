import { Component, Input, OnInit } from '@angular/core';
import { Panel } from '../../Models/Panel';

@Component({
  selector: 'app-panel',
  templateUrl: './panel.component.html',
  styleUrls: ['./panel.component.scss']
})
export class PanelComponent implements OnInit {

  @Input()
  public panel!: Panel;

  constructor() { }

  ngOnInit(): void {
  }

}
