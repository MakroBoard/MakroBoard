import { HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable()
export class AuthIntercepter implements HttpInterceptor
{
  constructor() { }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>>
  {
    console.log('intercepted request ... ');

    // Clone the request to add the new header.
    const authReq = req.clone({
      setHeaders: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        'Authorization': `${localStorage.getItem("token")}`,
      },
    });

    console.log('Sending request with new header now ...');

    //send the newly created request
    return next.handle(authReq);
  }
}
