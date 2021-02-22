// app/core/course.model.ts
import { Injectable } from "@angular/core";
import { Adapter } from "./aDAPTER";

export class Client
{
  constructor(
    public clientIp: string,
    public code: number,
    public id: number,
    public lastConnection: Date | undefined,
    public registerDate: Date | undefined,
    public token: string | undefined,
    public validUntil: Date | undefined,
    public state: ClientState)
  { }

  public StateConfirmed()
  {
    return this.state == ClientState.Confirmed;
  }

  public StateNone()
  {
    return this.state == ClientState.None;
  }
}

export enum ClientState
{
  None,
  Confirmed,
  Blocked
}

@Injectable({
  providedIn: "root",
})
export class ClientAdapter implements Adapter<Client>
{
  adapt(item: any): Client
  {
    return new Client(item.clientIp, item.code, item.id, new Date(item.lastConnection), new Date(item.registerDate), item.token, new Date(item.validUntil), item.state);
  }

}
