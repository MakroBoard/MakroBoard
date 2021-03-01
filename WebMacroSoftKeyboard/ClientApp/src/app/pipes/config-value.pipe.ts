import { Pipe, PipeTransform } from '@angular/core';
import { ConfigValue } from '../Models/ConfigValue';

@Pipe({
  name: 'configValue'
})
export class ConfigValuePipe implements PipeTransform {

  transform(value: Array<ConfigValue>, symbolicName: string): any
  {
    let result = value.find(cv => cv.symbolicName == symbolicName);
    return result;
  }

}
