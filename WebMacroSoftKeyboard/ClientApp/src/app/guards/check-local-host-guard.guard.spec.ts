import { TestBed } from '@angular/core/testing';

import { CheckLocalHostGuardGuard } from './check-local-host-guard.guard';

describe('CheckLocalHostGuardGuard', () => {
  let guard: CheckLocalHostGuardGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    guard = TestBed.inject(CheckLocalHostGuardGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
