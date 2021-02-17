import { PlatformLocation } from '@angular/common';
import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, UrlTree, Router } from '@angular/router';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CheckLocalHostGuardGuard implements CanActivate {
  constructor(private platformLocation: PlatformLocation) {
  }

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    let hostname = (this.platformLocation as any).location.hostname;
    if (hostname == "localhost") {
      return true;
    }
    return false;
  }

}
