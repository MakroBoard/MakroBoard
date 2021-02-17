import { TestBed } from '@angular/core/testing';

import { CheckServerTokenGuard } from './check-server-token.guard';

describe('CheckServerTokenGuard', () => {
  let guard: CheckServerTokenGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    guard = TestBed.inject(CheckServerTokenGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
