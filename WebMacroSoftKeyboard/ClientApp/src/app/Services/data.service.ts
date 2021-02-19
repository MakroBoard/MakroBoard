import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import * as signalR from "@microsoft/signalr";
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment.prod';
import { Client } from '../Models/Client';

@Injectable({
  providedIn: 'root'
})
export class DataService
{
  private clientsHubConnection: signalR.HubConnection

  constructor(private http: HttpClient)
  {
    this.clientsHubConnection = new signalR.HubConnectionBuilder()
      .withUrl(environment.hubUrl + 'clients')
      .build();
    this.clientsHubConnection
      .start()
      .then(() => console.log('Connection started'))
      .catch(err => console.log('Error while starting connection: ' + err))
  }

  public addClientsListener(): Observable<Client>
  {
    return new Observable<Client>((observableClients) =>
    {
      this.clientsHubConnection.on('AddSubmitCode', (client: Client) =>
      {
        observableClients.next(client);
      });
    });
  }

  public submitCode(code: number): Observable<Date>
  {
    return this.http.post<Date>(environment.apiUrl + "client/submitcode/", code, { responseType: 'json' })
      .pipe(map((d) => new Date(d.toString())));
  }
}
