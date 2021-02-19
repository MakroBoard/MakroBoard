import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../Services/config.service';

@Component({
  selector: 'app-config',
  templateUrl: './config.component.html',
  styleUrls: ['./config.component.scss']
})
export class ConfigComponent implements OnInit
{

  constructor(private configService: ConfigService) { }

  ngOnInit(): void
  {
    this.configService.getRequestTokens().subscribe({
      next: (data) =>
      {
      }
    })

  }

}
