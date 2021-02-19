import { PlatformLocation } from '@angular/common';
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'isLocalHost'
})
export class IsLocalHostPipe implements PipeTransform {
  constructor(private platformLocation: PlatformLocation) {
  }

  transform(value: string): boolean {
    let hostname = (this.platformLocation as any).location.hostname;
    if (hostname == "localhost") {
      return true;
    }
    return false;
  }

}
