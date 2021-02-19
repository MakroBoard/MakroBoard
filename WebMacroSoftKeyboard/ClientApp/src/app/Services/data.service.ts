import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment.prod';

@Injectable({
  providedIn: 'root'
})
export class DataService
{

  constructor(private http: HttpClient) { }

  public submitCode(code: number): Observable<Date>
  {
    return this.http.post<Date>(environment.apiUrl + "client/submitcode/", "", { responseType: 'json', params: new HttpParams().append("code", code.toString()) })
      .pipe(map((d) => new Date(d.toString())));
  }
}
