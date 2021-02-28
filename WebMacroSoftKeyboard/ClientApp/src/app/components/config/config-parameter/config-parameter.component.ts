import { Component, Input, OnInit } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { ConfigParameter } from '../../../Models/Controls';

@Component({
  selector: 'app-config-parameter',
  templateUrl: './config-parameter.component.html',
  styleUrls: ['./config-parameter.component.scss']
})
export class ConfigParameterComponent implements OnInit
{


  @Input()
  public configParameter: ConfigParameter | undefined;

  public formControl: FormControl = new FormControl();

  constructor()
  {
  }

  ngOnInit(): void
  {

  }

}
