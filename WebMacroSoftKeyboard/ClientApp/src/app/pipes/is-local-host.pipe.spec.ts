import { IsLocalHostPipe } from './is-local-host.pipe';

describe('IsLocalHostPipe', () => {
  it('create an instance', () => {
    const pipe = new IsLocalHostPipe();
    expect(pipe).toBeTruthy();
  });
});
