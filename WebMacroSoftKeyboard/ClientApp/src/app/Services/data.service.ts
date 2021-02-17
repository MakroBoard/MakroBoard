import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { environment } from '../../environments/environment.prod';

@Injectable({
  providedIn: 'root'
})
export class DataService {

  constructor(private http: HttpClient) { }

  public submitToken(token: number): Observable<Object> {
    return this.http.get(environment.apiUrl + "submittoken", { responseType: 'json', params: new HttpParams().append("token", token.toString()) });
  }
}
