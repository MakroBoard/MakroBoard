import { Pipe, PipeTransform } from '@angular/core';
import { IFilterable } from '../Models/Filterable';

@Pipe({
  name: 'filter'
})
export class FilterPipe implements PipeTransform
{
  transform(items: IFilterable[], searchText: string): any[]
  {
    if (searchText)
    {
      let newSearchTerm = searchText.toUpperCase();
      return items.filter(item => item.filter(newSearchTerm));
    }
    else
    {
      return items;
    }
  }
}
