import { Component, Input, OnInit } from '@angular/core';
import { Control } from '../../../Models/Controls';

@Component({
  selector: 'app-control',
  templateUrl: './control.component.html',
  styleUrls: ['./control.component.scss']
})
export class ControlComponent implements OnInit {

  @Input()
  public control: Control | undefined;
  constructor() { }

  ngOnInit(): void {
  }

}
