import { NativeModule, requireNativeModule } from 'expo';

import { ExpoAwsLivenessModuleEvents } from './ExpoAwsLiveness.types';

declare class ExpoAwsLivenessModule extends NativeModule<ExpoAwsLivenessModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<ExpoAwsLivenessModule>('ExpoAwsLiveness');
