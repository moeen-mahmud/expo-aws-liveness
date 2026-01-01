import { registerWebModule, NativeModule } from 'expo';

import { ExpoAwsLivenessModuleEvents } from './ExpoAwsLiveness.types';

class ExpoAwsLivenessModule extends NativeModule<ExpoAwsLivenessModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(ExpoAwsLivenessModule, 'ExpoAwsLivenessModule');
