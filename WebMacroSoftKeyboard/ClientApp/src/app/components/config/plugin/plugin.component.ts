import { Component, Input, OnInit } from '@angular/core';
import { Plugin } from '../../../Models/Controls';

@Component({
  selector: 'app-plugin',
  templateUrl: './plugin.component.html',
  styleUrls: ['./plugin.component.scss']
})
export class PluginComponent implements OnInit {

  @Input()
  public plugin: Plugin | undefined;

  constructor() { }

  ngOnInit(): void {
  }

}
