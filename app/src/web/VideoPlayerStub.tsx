import React from 'react';
import { WebPlayer } from './WebPlayer';

type Props = {
  source?: { uri?: string };
  paused?: boolean;
  onError?: (e: { error: { errorString: string } }) => void;
  onLoad?: () => void;
  [key: string]: unknown;
};

export default function Video({ source, paused, onError, onLoad }: Props) {
  const uri = source?.uri ?? '';
  return (
    <WebPlayer
      uri={uri}
      paused={paused}
      onLoad={onLoad}
      onError={(msg) => onError?.({ error: { errorString: msg } })}
    />
  );
}
