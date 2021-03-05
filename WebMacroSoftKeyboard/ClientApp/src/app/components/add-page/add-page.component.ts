import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-add-page',
  templateUrl: './add-page.component.html',
  styleUrls: ['./add-page.component.scss']
})
export class AddPageComponent implements OnInit {

  public icon: string = "web";
  public label: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}
