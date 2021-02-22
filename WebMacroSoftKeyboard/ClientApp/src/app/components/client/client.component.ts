import { Component, Input, OnInit } from '@angular/core';
import { Observable, Subscription, timer } from 'rxjs';
import { Client } from '../../Models/Client';
import { DataService } from '../../Services/data.service';

@Component({
  selector: 'app-client',
  templateUrl: './client.component.html',
  styleUrls: ['./client.component.scss']
})
export class ClientComponent implements OnInit
{

  private progressTimer: Observable<number> = timer(0, 1000);
  private ValidDuration: number = 0;
  public Code: number = 0;
  public ValidUntil: Date | undefined = undefined;
  public Progress: number = 0;
  private progressTimerSubscription: Subscription | undefined = undefined;


  @Input()
  get client(): Client | undefined { return this._client; }
  set client(client: Client | undefined)
  {
    this._client = client;

    if (this._client == undefined || this._client.ValidUntil == undefined)
    {
      return;
    }

    this.ValidDuration = this._client.ValidUntil.getTime() - new Date().getTime();
    this.progressTimerSubscription = this.progressTimer.subscribe(() =>
    {
      if (this._client != undefined && this._client.ValidUntil != undefined)
      {
        let remaining = this._client.ValidUntil.getTime() - new Date().getTime();
        this.Progress = remaining / this.ValidDuration * 100.0;
        if (this.Progress >= 100 && this.progressTimerSubscription != undefined)
        {
          this.progressTimerSubscription.unsubscribe();
        }
      }
    });
  }
  private _client: Client | undefined;


  constructor(private dataService: DataService) { }

  ngOnInit(): void
  {
  }


  confirmClient()
  {
    if (this.client != undefined)
    {
      this.dataService.confirmClient(this.client).subscribe({
        error: e =>
        {
          console.log(e);
        }
      });
    }
  }
}
