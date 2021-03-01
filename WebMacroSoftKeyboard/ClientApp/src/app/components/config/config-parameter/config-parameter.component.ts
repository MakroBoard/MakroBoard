import { Component, Input, OnInit, Output } from '@angular/core';
import { FormControl, Validators } from '@angular/forms';
import { ConfigValue } from "../../../Models/ConfigValue";
import { ConfigParameter } from "../../../Models/ConfigParameter";

@Component({
  selector: 'app-config-parameter',
  templateUrl: './config-parameter.component.html',
  styleUrls: ['./config-parameter.component.scss']
})
export class ConfigParameterComponent implements OnInit
{


  @Input()
  public configParameter!: ConfigParameter;

  @Input()
  public value!: ConfigValue;

  public formControl: FormControl = new FormControl();

  constructor()
  {
  }

  ngOnInit(): void
  {

  }

}
