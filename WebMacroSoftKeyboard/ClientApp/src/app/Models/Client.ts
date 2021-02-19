export interface Client
{
  clientIp: string;
  code: number;
  id: number;
  lastConnection: Date | undefined;
  registerDate: Date | undefined;
  token: string | undefined;
  validUntil: Date | undefined;
}
