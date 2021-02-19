import { Component, OnInit } from '@angular/core';
import { Client } from '../../Models/Client';
import { DataService } from '../../Services/data.service';

@Component({
  selector: 'app-config',
  templateUrl: './config.component.html',
  styleUrls: ['./config.component.scss']
})
export class ConfigComponent implements OnInit
{

  public clients: Client[] = new Array<Client>();

  constructor(private dataService: DataService) { }

  ngOnInit(): void
  {
    this.dataService.addClientsListener().subscribe({
      next: (client: Client) =>
      {
        this.clients.push(client);
      }
    });
    //this.configService.getRequestTokens().subscribe({
    //  next: (data) =>
    //  {
    //  }
    //})

  }

}
