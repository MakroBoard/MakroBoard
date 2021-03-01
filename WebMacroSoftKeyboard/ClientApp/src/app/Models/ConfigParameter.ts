
export class ConfigParameter
{
  constructor(
    public symbolicName: string,
    public parameterType: string,
    public validationRegEx: string,
    public minValue: number,
    public maxValue: number) { }
}
