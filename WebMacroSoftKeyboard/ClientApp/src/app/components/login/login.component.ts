import { Component, OnInit } from '@angular/core';
import { DataService } from '../../Services/data.service';
import { Observable, Subscription, timer } from 'rxjs';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit
{

  private progressTimer: Observable<number> = timer(0, 1000);
  private ValidDuration: number = 0;
  public Code: number = 0;
  public ValidUntil: Date | undefined = undefined;
  public Progress: number = 0;
  private progressTimerSubscription: Subscription | undefined = undefined;

  constructor(private dataService: DataService)
  {

  }

  ngOnInit(): void
  {
    this.setNewToken();
  }

  setNewToken()
  {
    this.Code = this.getRandomInt(10000, 99999);
    this.dataService.submitCode(this.Code).subscribe({
      next: validUntil =>
      {
        this.ValidUntil = validUntil;
        this.ValidDuration = this.ValidUntil.getTime() - new Date().getTime();
        this.progressTimerSubscription = this.progressTimer.subscribe(() =>
        {
          if (this.ValidUntil != undefined)
          {
            let remaining = this.ValidUntil.getTime() - new Date().getTime();
            this.Progress = remaining / this.ValidDuration * 100.0;
            if (this.Progress <= 0 && this.progressTimerSubscription != undefined)
            {
              this.progressTimerSubscription.unsubscribe();
              this.setNewToken();
            }
          }
        });
      },
      error: e =>
      {
        // TODO
      },
    });
  }


  /**
   * Returns a random integer between min (inclusive) and max (inclusive).
   * The value is no lower than min (or the next integer greater than min
   * if min isn't an integer) and no greater than max (or the next integer
   * lower than max if max isn't an integer).
   * Using Math.round() will give you a non-uniform distribution!
   */
  getRandomInt(min: number, max: number): number
  {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }
}
