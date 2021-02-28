import { Component, EventEmitter, OnInit } from '@angular/core';
import { MatTabChangeEvent } from '@angular/material/tabs';
import { Client } from '../../Models/Client';
import { DataService } from '../../Services/data.service';

@Component({
  selector: 'app-config',
  templateUrl: './config.component.html',
  styleUrls: ['./config.component.scss']
})
export class ConfigComponent implements OnInit
{
  public selectedTab: number;
  public clients: Client[] = new Array<Client>();

  constructor(private dataService: DataService)
  {
    this.selectedTab = +(localStorage.getItem("configTabIndex") ?? 0);
  }

  ngOnInit(): void
  {
    this.dataService.onClientAddOrUpdate().subscribe({
      next: (client: Client) =>
      {
        let oldClient = this.clients.find(c => c.ClientIp == client.ClientIp);
        if (oldClient != undefined)
        {
          const index = this.clients.indexOf(oldClient, 0);
          if (index > -1)
          {
            this.clients.splice(index, 1);
          }
        }

        this.clients.push(client);
      }
    });

    this.dataService.onClientRemove().subscribe({
      next: (client: Client) =>
      {
        let oldClient = this.clients.find(c => c.ClientIp == client.ClientIp);
        if (oldClient != undefined)
        {
          const index = this.clients.indexOf(oldClient, 0);
          if (index > -1)
          {
            this.clients.splice(index, 1);
          }
        }
      }
    });

  }

  selectedTabChanged(selectedTab: number): void
  {
    this.selectedTab = selectedTab;
    localStorage.setItem("configTabIndex", this.selectedTab.toString());
  }
}
