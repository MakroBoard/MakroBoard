import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { Observable } from 'rxjs';
import { DataService } from '../Services/data.service';

@Injectable({
  providedIn: 'root'
})
export class CheckServerTokenGuard implements CanActivate
{
  constructor(private router: Router, private dataServive: DataService) { }


  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree
  {

    return this.dataServive.checkToken().then(result =>
    {
      if (!result)
      {
        return this.router.parseUrl('/login');
      }
      return true;
    });
  }
}
