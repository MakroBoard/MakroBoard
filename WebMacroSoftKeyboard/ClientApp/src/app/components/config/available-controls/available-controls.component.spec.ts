import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AvailableControlsComponent } from './available-controls.component';

describe('AvailableControlsComponent', () => {
  let component: AvailableControlsComponent;
  let fixture: ComponentFixture<AvailableControlsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AvailableControlsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AvailableControlsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
