import React, { useEffect, useRef } from 'react';
import Hls from 'hls.js';

type WebPlayerProps = {
  uri: string;
  paused?: boolean;
  onError?: (msg: string) => void;
  onLoad?: () => void;
};

export function WebPlayer({ uri, paused, onError, onLoad }: WebPlayerProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const hlsRef = useRef<Hls | null>(null);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) { return; }

    if (Hls.isSupported()) {
      const hls = new Hls();
      hlsRef.current = hls;
      hls.loadSource(uri);
      hls.attachMedia(video);
      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        onLoad?.();
        if (!paused) { video.play().catch(() => {}); }
      });
      hls.on(Hls.Events.ERROR, (_event, data) => {
        if (data.fatal) {
          onError?.(data.details ?? 'HLS error');
        }
      });
    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
      video.src = uri;
      video.addEventListener('loadedmetadata', () => {
        onLoad?.();
        if (!paused) { video.play().catch(() => {}); }
      });
    } else {
      onError?.('HLS not supported in this browser');
    }

    return () => {
      hlsRef.current?.destroy();
      hlsRef.current = null;
    };
  }, [uri]);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) { return; }
    if (paused) {
      video.pause();
    } else {
      video.play().catch(() => {});
    }
  }, [paused]);

  return (
    <video
      ref={videoRef}
      // eslint-disable-next-line react-native/no-inline-styles
      style={{ width: '100%', height: '100%', objectFit: 'contain', backgroundColor: '#000' }}
    />
  );
}
