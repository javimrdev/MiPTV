import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import Video, {
  IgnoreSilentSwitchType,
  OnBufferData,
  OnLoadData,
  OnVideoErrorData,
  ResizeMode,
  VideoRef,
} from 'react-native-video';
import Orientation from 'react-native-orientation-locker';
import type { RootStackScreenProps } from '../navigation/types';
import { usePlayerStore } from '../store/playerStore';

export function PlayerScreen({ route, navigation }: RootStackScreenProps<'Player'>) {
  const { channelId, streamUrl, channelName } = route.params;
  const videoRef = useRef<VideoRef>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { setChannel, setPlaying } = usePlayerStore();

  useEffect(() => {
    Orientation.lockToLandscape();
    StatusBar.setHidden(true);
    setChannel({
      id: channelId,
      providerId: '',
      name: channelName,
      streamUrl,
      logoUrl: null,
      group: '',
      country: null,
      tvgId: null,
      catchupSupport: false,
    });
    return () => {
      Orientation.lockToPortrait();
      StatusBar.setHidden(false);
      setChannel(null);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleBuffer = useCallback(({ isBuffering }: OnBufferData) => {
    setLoading(isBuffering);
  }, []);

  const handleLoad = useCallback((_data: OnLoadData) => {
    setLoading(false);
    setError(null);
    setPlaying(true);
  }, [setPlaying]);

  const handleError = useCallback(({ error: err }: OnVideoErrorData) => {
    const message = err.errorString ?? err.localizedDescription ?? err.error ?? 'Stream error';
    setLoading(false);
    setError(message);
    setPlaying(false);
  }, [setPlaying]);

  const retry = useCallback(() => {
    setError(null);
    setLoading(true);
  }, []);

  return (
    <View style={styles.container}>
      {!error && (
        <Video
          ref={videoRef}
          source={{ uri: streamUrl, metadata: { title: channelName, artist: 'MiPTV' } }}
          style={StyleSheet.absoluteFill}
          resizeMode={ResizeMode.CONTAIN}
          onBuffer={handleBuffer}
          onLoad={handleLoad}
          onError={handleError}
          playInBackground
          playWhenInactive
          ignoreSilentSwitch={IgnoreSilentSwitchType.IGNORE}
          showNotificationControls
        />
      )}

      {loading && !error && (
        <View style={styles.overlay}>
          <ActivityIndicator size="large" color="#fff" />
        </View>
      )}

      {error && (
        <View style={styles.overlay}>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity style={styles.retryBtn} onPress={retry}>
            <Text style={styles.retryText}>Retry</Text>
          </TouchableOpacity>
        </View>
      )}

      <View style={styles.header}>
        <Text style={styles.channelName} numberOfLines={1}>{channelName}</Text>
        <TouchableOpacity onPress={() => navigation.goBack()} hitSlop={12}>
          <Text style={styles.closeText}>✕</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000' },
  overlay: { ...StyleSheet.absoluteFillObject, alignItems: 'center', justifyContent: 'center' },
  header: {
    position: 'absolute',
    top: 16,
    left: 16,
    right: 16,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  channelName: { color: '#fff', fontSize: 16, fontWeight: '600', flex: 1, marginRight: 12 },
  closeText: { color: '#fff', fontSize: 24 },
  errorText: { color: '#ff4444', fontSize: 14, textAlign: 'center', marginBottom: 12 },
  retryBtn: {
    borderWidth: 1,
    borderColor: '#fff',
    borderRadius: 6,
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  retryText: { color: '#fff', fontSize: 14 },
});
