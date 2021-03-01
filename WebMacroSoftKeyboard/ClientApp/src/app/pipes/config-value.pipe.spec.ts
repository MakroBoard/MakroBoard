import { ConfigValuePipe } from './config-value.pipe';

describe('ConfigValuePipe', () => {
  it('create an instance', () => {
    const pipe = new ConfigValuePipe();
    expect(pipe).toBeTruthy();
  });
});
