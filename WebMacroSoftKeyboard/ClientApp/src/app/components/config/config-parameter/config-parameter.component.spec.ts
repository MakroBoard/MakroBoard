import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ConfigParameterComponent } from './config-parameter.component';

describe('ConfigParameterComponent', () => {
  let component: ConfigParameterComponent;
  let fixture: ComponentFixture<ConfigParameterComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ConfigParameterComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ConfigParameterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
