import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoAwsLivenessViewProps } from './ExpoAwsLiveness.types';

const NativeView: React.ComponentType<ExpoAwsLivenessViewProps> =
  requireNativeView('ExpoAwsLiveness');

export default function ExpoAwsLivenessView(props: ExpoAwsLivenessViewProps) {
  return <NativeView {...props} />;
}
