import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Client } from '../Models/Client';

@Injectable({
  providedIn: 'root'
})
export class ConfigService
{
  constructor(private http: HttpClient) { }

  public getRequestTokens(): Observable<Client[]>
  {
    return this.http.get<Client[]>(environment.apiUrl + "client/requesttokens/", { responseType: 'json' });
  }
}
