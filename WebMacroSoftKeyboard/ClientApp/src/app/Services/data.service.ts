import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import * as signalR from "@microsoft/signalr";
import { error } from 'protractor';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment.prod';
import { Client, ClientAdapter } from '../Models/Client';
import { ConfigValue } from '../Models/ConfigValue';
import { ControlsAdapter } from "../Models/ControlsAdapter";
import { Plugin } from "../Models/Plugin";

@Injectable({
  providedIn: 'root'
})
export class DataService
{

  private clientsHubConnection: signalR.HubConnection
  private clientCache: Array<Client> = new Array<Client>();

  constructor(private http: HttpClient, private clientAdapter: ClientAdapter, private controlsAdapter: ControlsAdapter)
  {
    this.clientsHubConnection = new signalR.HubConnectionBuilder()
      .withUrl(environment.hubUrl + 'clients')
      .build();
    this.initCache();
    this.clientsHubConnection
      .start()
      .then(() => console.log('Connection started'))
      .catch(err => console.log('Error while starting connection: ' + err));
  }

  private initCache(): void
  {
    this.onClientAddOrUpdate().subscribe({
      next: client =>
      {
        this.removeOldClientFromCache(client);
        this.clientCache.push(client);
      }
    });
    this.onClientRemove().subscribe({
      next: client =>
      {
        this.removeOldClientFromCache(client);
      }
    });
    this.onAddOrUpdateToken();
  }

  private removeOldClientFromCache(client: Client)
  {
    let oldClient = this.clientCache.find(c => c.ClientIp == client.ClientIp);
    if (oldClient != undefined)
    {
      const index = this.clientCache.indexOf(oldClient, 0);
      if (index > -1)
      {
        this.clientCache.splice(index, 1);
      }
    }
  }

  public onClientAddOrUpdate(): Observable<Client>
  {
    return new Observable<Client>((observableClients) =>
    {
      this.clientCache.forEach(c => observableClients.next(c));

      this.clientsHubConnection.on('AddOrUpdateClient', (client: Client) =>
      {
        observableClients.next(this.clientAdapter.adapt(client));
      });
    });
  }

  public onClientRemove(): Observable<Client>
  {
    return new Observable<Client>((observableClients) =>
    {
      this.clientsHubConnection.on('RemoveClient', (client: Client) =>
      {
        localStorage.removeItem('token');
        observableClients.next(this.clientAdapter.adapt(client));
      });
    });
  }

  public onAddOrUpdateToken(): Observable<string>
  {
    return new Observable<string>((observableTokens) =>
    {
      this.clientsHubConnection.on('AddOrUpdateToken', (token: string) =>
      {
        localStorage.setItem('token', token);
        observableTokens.next(token);
      });
    });
  }

  public async checkToken(): Promise<boolean>
  {
    var token = localStorage.getItem('token');
    if (token == null)
    {
      return false;
    }
    else
    {
      var isTokenValid = await this.http.get<boolean>(environment.apiUrl + "client/checktoken/", { responseType: 'json' }).toPromise();
      return isTokenValid;
    }
  }

  public submitCode(code: number): Observable<Date>
  {
    return this.http.post<Date>(environment.apiUrl + "client/submitcode/", code, { responseType: 'json' })
      .pipe(map((d) => new Date(d.toString())));
  }

  public confirmClient(client: Client): Observable<any>
  {
    return this.http.post(environment.apiUrl + "client/confirmclient/", client, { responseType: 'json' });
  }

  public removeClient(client: Client): Observable<any>
  {
    return this.http.post(environment.apiUrl + "client/removeClient/", client, { responseType: 'json' });
  }

  public getAvailableControls(): Promise<Array<Plugin>>
  {
    return this.http.get(environment.apiUrl + "controls/availablecontrols/", { responseType: 'json' })
      .pipe(map((d) => (d as Array<any>).map(p => this.controlsAdapter.adapt(p)))).toPromise();
  }

  public executeControl(symbolicName: string, configValues: Array<ConfigValue>): Promise<any>
  {
    return this.http.post(environment.apiUrl + "controls/execute/", { symbolicName: symbolicName, configValues: configValues }, { responseType: 'json' }).toPromise();
  }

  public addNewPage(label: string, icon: string): Promise<any>
  {
    return this.http.post(environment.apiUrl + "layout/addpage/", { label: label, icon: icon }, { responseType: 'json' }).toPromise();
  }
}
