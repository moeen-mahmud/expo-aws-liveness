import * as React from 'react';

import { ExpoAwsLivenessViewProps } from './ExpoAwsLiveness.types';

export default function ExpoAwsLivenessView(props: ExpoAwsLivenessViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
