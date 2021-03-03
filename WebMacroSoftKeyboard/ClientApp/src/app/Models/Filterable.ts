// app/core/adapter.ts
export interface IFilterable
{
  filter(filterText: string): boolean;
}
