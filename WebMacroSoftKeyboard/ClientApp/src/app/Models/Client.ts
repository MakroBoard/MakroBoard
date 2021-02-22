// app/core/course.model.ts
import { Injectable } from "@angular/core";
import { Adapter } from "./aDAPTER";

export class Client
{
  constructor(
    public ID: number,
    public Code: number,
    public ValidUntil: Date | undefined,
    public Token: string | undefined,
    public ClientIp: string,
    public RegisterDate: Date | undefined,
    public LastConnection: Date | undefined,
    public State: ClientState)
  { }

  public StateConfirmed()
  {
    return this.State == ClientState.Confirmed;
  }

  public StateNone()
  {
    return this.State == ClientState.None;
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
    return new Client(item.id, item.code, new Date(item.validUntil), item.token, item.clientIp, new Date(item.registerDate), new Date(item.lastConnection), item.state);
  }

}
