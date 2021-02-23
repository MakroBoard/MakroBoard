import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import * as signalR from "@microsoft/signalr";
import { error } from 'protractor';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment.prod';
import { Client, ClientAdapter } from '../Models/Client';

@Injectable({
  providedIn: 'root'
})
export class DataService
{
  private clientsHubConnection: signalR.HubConnection

  constructor(private http: HttpClient, private clientAdapter: ClientAdapter)
  {
    this.clientsHubConnection = new signalR.HubConnectionBuilder()
      .withUrl(environment.hubUrl + 'clients')
      .build();
    this.clientsHubConnection
      .start()
      .then(() => console.log('Connection started'))
      .catch(err => console.log('Error while starting connection: ' + err))
  }

  public onClientAddOrUpdate(): Observable<Client>
  {
    return new Observable<Client>((observableClients) =>
    {
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

}
