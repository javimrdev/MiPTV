import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  AppState,
  Modal,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import Animated, {
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';
import Video, {
  AudioTrack,
  IgnoreSilentSwitchType,
  OnBufferData,
  OnLoadData,
  OnPictureInPictureStatusChangedData,
  OnProgressData,
  OnVideoErrorData,
  OnVideoTracksData,
  ResizeMode,
  SelectedTrack,
  SelectedTrackType,
  SelectedVideoTrack,
  SelectedVideoTrackType,
  TextTrack,
  VideoRef,
  VideoTrack,
} from 'react-native-video';
import Orientation from 'react-native-orientation-locker';
import type { RootStackScreenProps } from '../navigation/types';
import { usePlayerStore } from '../store/playerStore';

const FADE_MS = 250;
const AUTO_HIDE_MS = 4000;

// ─── Track picker modal ───────────────────────────────────────────────────────

type TrackPickerProps = {
  title: string;
  items: { label: string; index: number; selected: boolean }[];
  onSelect: (index: number) => void;
  onClose: () => void;
};

function TrackPickerModal({ title, items, onSelect, onClose }: TrackPickerProps) {
  return (
    <Modal transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={styles.modalBackdrop} activeOpacity={1} onPress={onClose}>
        <View style={styles.pickerSheet}>
          <Text style={styles.pickerTitle}>{title}</Text>
          <ScrollView>
            {items.map(item => (
              <TouchableOpacity
                key={item.index}
                style={styles.pickerItem}
                onPress={() => { onSelect(item.index); onClose(); }}>
                <Text style={[styles.pickerItemText, item.selected && styles.pickerItemSelected]}>
                  {item.selected ? '● ' : '○ '}{item.label}
                </Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>
      </TouchableOpacity>
    </Modal>
  );
}

// ─── Player screen ────────────────────────────────────────────────────────────

export function PlayerScreen({ route, navigation }: RootStackScreenProps<'Player'>) {
  const { channelId, streamUrl, channelName } = route.params;
  const videoRef = useRef<VideoRef>(null);
  const autoHideRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const volumeStartRef = useRef(1);
  const sliderWidthRef = useRef(0);

  // Playback state
  const [paused, setPaused] = useState(false);
  const [isPiP, setIsPiP] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const [volume, setVolume] = useState(1);

  // Track state
  const [audioTracks, setAudioTracks] = useState<AudioTrack[]>([]);
  const [textTracks, setTextTracks] = useState<TextTrack[]>([]);
  const [videoTracks, setVideoTracks] = useState<VideoTrack[]>([]);
  const [selAudio, setSelAudio] = useState<SelectedTrack>({ type: SelectedTrackType.SYSTEM });
  const [selText, setSelText] = useState<SelectedTrack>({ type: SelectedTrackType.DISABLED });
  const [selVideo, setSelVideo] = useState<SelectedVideoTrack>({ type: SelectedVideoTrackType.AUTO });
  const [trackPicker, setTrackPicker] = useState<'audio' | 'text' | 'video' | null>(null);

  // Controls overlay animation
  const controlsVisible = useSharedValue(1);
  const controlsStyle = useAnimatedStyle(() => ({ opacity: controlsVisible.value }));

  const { setChannel, setPlaying } = usePlayerStore();

  // ── Auto-hide logic ─────────────────────────────────────────────────────────

  const scheduleAutoHide = useCallback(() => {
    if (autoHideRef.current) { clearTimeout(autoHideRef.current); }
    autoHideRef.current = setTimeout(() => {
      controlsVisible.value = withTiming(0, { duration: FADE_MS });
    }, AUTO_HIDE_MS);
  }, [controlsVisible]);

  const showControls = useCallback(() => {
    controlsVisible.value = withTiming(1, { duration: FADE_MS });
    scheduleAutoHide();
  }, [controlsVisible, scheduleAutoHide]);

  const toggleControls = useCallback(() => {
    if (controlsVisible.value > 0.5) {
      if (autoHideRef.current) { clearTimeout(autoHideRef.current); }
      controlsVisible.value = withTiming(0, { duration: FADE_MS });
    } else {
      showControls();
    }
  }, [controlsVisible, showControls]);

  // ── PiP ─────────────────────────────────────────────────────────────────────

  const handlePiPStatusChanged = useCallback(({ isActive }: OnPictureInPictureStatusChangedData) => {
    setIsPiP(isActive);
    if (isActive) {
      if (autoHideRef.current) { clearTimeout(autoHideRef.current); }
      controlsVisible.value = withTiming(0, { duration: FADE_MS });
    } else {
      showControls();
    }
  }, [controlsVisible, showControls]);

  // Auto-enter PiP when the app is backgrounded while the player is mounted
  useEffect(() => {
    const sub = AppState.addEventListener('change', nextState => {
      if (nextState === 'background') {
        videoRef.current?.enterPictureInPicture();
      }
    });
    return () => sub.remove();
  }, []);

  // ── Mount / unmount ─────────────────────────────────────────────────────────

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
    scheduleAutoHide();
    return () => {
      if (autoHideRef.current) { clearTimeout(autoHideRef.current); }
      Orientation.lockToPortrait();
      StatusBar.setHidden(false);
      setChannel(null);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // ── Video event handlers ────────────────────────────────────────────────────

  const handleBuffer = useCallback(({ isBuffering }: OnBufferData) => {
    setLoading(isBuffering);
  }, []);

  const handleLoad = useCallback((data: OnLoadData) => {
    setLoading(false);
    setError(null);
    setPlaying(true);
    setDuration(data.duration ?? 0);
  }, [setPlaying]);

  const handleProgress = useCallback(({ currentTime: ct }: OnProgressData) => {
    setCurrentTime(ct);
  }, []);

  const handleError = useCallback(({ error: err }: OnVideoErrorData) => {
    const msg = err.errorString ?? err.localizedDescription ?? err.error ?? 'Stream error';
    setLoading(false);
    setError(msg);
    setPlaying(false);
  }, [setPlaying]);

  const handleAudioTracks = useCallback(({ audioTracks: tracks }: { audioTracks: AudioTrack[] }) => {
    setAudioTracks(tracks);
  }, []);

  const handleTextTracks = useCallback(({ textTracks: tracks }: { textTracks: TextTrack[] }) => {
    setTextTracks(tracks);
  }, []);

  const handleVideoTracks = useCallback(({ videoTracks: tracks }: OnVideoTracksData) => {
    setVideoTracks(tracks);
  }, []);

  const retry = useCallback(() => {
    setError(null);
    setLoading(true);
  }, []);

  // ── Playback controls ───────────────────────────────────────────────────────

  const togglePause = useCallback(() => {
    setPaused(p => !p);
    showControls();
  }, [showControls]);

  const seekRelative = useCallback((delta: number) => {
    videoRef.current?.seek(Math.max(0, currentTime + delta));
    showControls();
  }, [currentTime, showControls]);

  // ── Volume slider gesture ───────────────────────────────────────────────────

  const volumeGesture = Gesture.Pan()
    .onBegin(() => {
      volumeStartRef.current = volume;
      runOnJS(showControls)();
    })
    .onUpdate(e => {
      if (sliderWidthRef.current === 0) { return; }
      const newVol = Math.max(0, Math.min(1, volumeStartRef.current + e.translationX / sliderWidthRef.current));
      runOnJS(setVolume)(newVol);
    });

  // ── Seek bar tap gesture ────────────────────────────────────────────────────

  const seekBarWidthRef = useRef(0);
  const seekGesture = Gesture.Tap()
    .onEnd(e => {
      if (seekBarWidthRef.current === 0 || duration === 0) { return; }
      const seekTo = (e.x / seekBarWidthRef.current) * duration;
      runOnJS(showControls)();
      videoRef.current?.seek(seekTo);
    });

  // ── Track picker helpers ────────────────────────────────────────────────────

  const audioPickerItems = audioTracks.map((t, i) => ({
    index: i,
    label: t.language ?? t.title ?? `Track ${i + 1}`,
    selected: selAudio.type === SelectedTrackType.INDEX && selAudio.value === i,
  }));

  const textPickerItems = [
    { index: -1, label: 'Off', selected: selText.type === SelectedTrackType.DISABLED },
    ...textTracks.map((t, i) => ({
      index: i,
      label: t.language ?? t.title ?? `Sub ${i + 1}`,
      selected: selText.type === SelectedTrackType.INDEX && selText.value === i,
    })),
  ];

  const videoPickerItems = [
    { index: -1, label: 'Auto', selected: selVideo.type === SelectedVideoTrackType.AUTO },
    ...videoTracks.map((t, i) => ({
      index: i,
      label: t.height ? `${t.height}p` : `Quality ${i + 1}`,
      selected: selVideo.type === SelectedVideoTrackType.INDEX && selVideo.value === i,
    })),
  ];

  // ── Format helpers ──────────────────────────────────────────────────────────

  const fmt = (s: number) => {
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    const sec = Math.floor(s % 60);
    return h > 0
      ? `${h}:${String(m).padStart(2, '0')}:${String(sec).padStart(2, '0')}`
      : `${m}:${String(sec).padStart(2, '0')}`;
  };

  const tapGesture = Gesture.Tap().onEnd(() => runOnJS(toggleControls)());

  // ── Render ──────────────────────────────────────────────────────────────────

  return (
    <View style={styles.container}>
      {/* Video */}
      {!error && (
        <Video
          ref={videoRef}
          source={{ uri: streamUrl, metadata: { title: channelName, artist: 'MiPTV' } }}
          style={StyleSheet.absoluteFill}
          resizeMode={ResizeMode.CONTAIN}
          paused={paused}
          volume={volume}
          selectedAudioTrack={selAudio}
          selectedTextTrack={selText}
          selectedVideoTrack={selVideo}
          onBuffer={handleBuffer}
          onLoad={handleLoad}
          onProgress={handleProgress}
          onError={handleError}
          onAudioTracks={handleAudioTracks}
          onTextTracks={handleTextTracks}
          onVideoTracks={handleVideoTracks}
          playInBackground
          playWhenInactive
          ignoreSilentSwitch={IgnoreSilentSwitchType.IGNORE}
          showNotificationControls
          onPictureInPictureStatusChanged={handlePiPStatusChanged}
        />
      )}

      {/* Buffering */}
      {loading && !error && (
        <View style={styles.centeredOverlay}>
          <ActivityIndicator size="large" color="#fff" />
        </View>
      )}

      {/* Error */}
      {error && (
        <View style={styles.centeredOverlay}>
          <Text style={styles.errorText}>{error}</Text>
          <TouchableOpacity style={styles.retryBtn} onPress={retry}>
            <Text style={styles.retryText}>Retry</Text>
          </TouchableOpacity>
        </View>
      )}

      {/* Tap zone + animated controls */}
      <GestureDetector gesture={tapGesture}>
        <Animated.View style={[StyleSheet.absoluteFill, styles.controls, controlsStyle]}>
          {/* Top bar */}
          <View style={styles.topBar}>
            <Text style={styles.channelName} numberOfLines={1}>{channelName}</Text>
            {!isPiP && (
              <TouchableOpacity
                onPress={() => videoRef.current?.enterPictureInPicture()}
                hitSlop={12}
                style={styles.topBarBtn}>
                <Text style={styles.topBarBtnText}>PiP</Text>
              </TouchableOpacity>
            )}
            <TouchableOpacity onPress={() => navigation.goBack()} hitSlop={12}>
              <Text style={styles.closeBtn}>✕</Text>
            </TouchableOpacity>
          </View>

          {/* Center: seek + play/pause */}
          <View style={styles.center}>
            <TouchableOpacity onPress={() => seekRelative(-30)} hitSlop={8}>
              <Text style={styles.seekBtn}>⏪ 30</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={togglePause} style={styles.playBtn}>
              <Text style={styles.playBtnText}>{paused ? '▶' : '⏸'}</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={() => seekRelative(30)} hitSlop={8}>
              <Text style={styles.seekBtn}>30 ⏩</Text>
            </TouchableOpacity>
          </View>

          {/* Bottom: progress + volume + track pickers */}
          <View style={styles.bottomBar}>
            {/* Progress bar (only for non-live) */}
            {duration > 0 && (
              <View style={styles.progressRow}>
                <Text style={styles.timeText}>{fmt(currentTime)}</Text>
                <GestureDetector gesture={seekGesture}>
                  <View
                    style={styles.progressTrack}
                    onLayout={e => { seekBarWidthRef.current = e.nativeEvent.layout.width; }}>
                    <View style={[styles.progressFill, { width: `${(currentTime / duration) * 100}%` }]} />
                  </View>
                </GestureDetector>
                <Text style={styles.timeText}>{fmt(duration)}</Text>
              </View>
            )}

            {/* Volume + track buttons */}
            <View style={styles.controlsRow}>
              {/* Volume slider */}
              <Text style={styles.trackIcon}>🔊</Text>
              <GestureDetector gesture={volumeGesture}>
                <View
                  style={styles.volumeTrack}
                  onLayout={e => { sliderWidthRef.current = e.nativeEvent.layout.width; }}>
                  <View style={[styles.volumeFill, { width: `${volume * 100}%` }]} />
                  <View style={[styles.volumeThumb, { left: `${volume * 100}%` as unknown as number }]} />
                </View>
              </GestureDetector>

              {/* Track selectors */}
              {textTracks.length > 0 && (
                <TouchableOpacity onPress={() => setTrackPicker('text')} style={styles.trackBtn}>
                  <Text style={styles.trackIcon}>CC</Text>
                </TouchableOpacity>
              )}
              {audioTracks.length > 1 && (
                <TouchableOpacity onPress={() => setTrackPicker('audio')} style={styles.trackBtn}>
                  <Text style={styles.trackIcon}>🎵</Text>
                </TouchableOpacity>
              )}
              {videoTracks.length > 1 && (
                <TouchableOpacity onPress={() => setTrackPicker('video')} style={styles.trackBtn}>
                  <Text style={styles.trackIcon}>HD</Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
        </Animated.View>
      </GestureDetector>

      {/* Track picker modals */}
      {trackPicker === 'audio' && (
        <TrackPickerModal
          title="Audio Track"
          items={audioPickerItems}
          onSelect={i => setSelAudio({ type: SelectedTrackType.INDEX, value: i })}
          onClose={() => setTrackPicker(null)}
        />
      )}
      {trackPicker === 'text' && (
        <TrackPickerModal
          title="Subtitles"
          items={textPickerItems}
          onSelect={i =>
            setSelText(i === -1
              ? { type: SelectedTrackType.DISABLED }
              : { type: SelectedTrackType.INDEX, value: i })}
          onClose={() => setTrackPicker(null)}
        />
      )}
      {trackPicker === 'video' && (
        <TrackPickerModal
          title="Quality"
          items={videoPickerItems}
          onSelect={i =>
            setSelVideo(i === -1
              ? { type: SelectedVideoTrackType.AUTO }
              : { type: SelectedVideoTrackType.INDEX, value: i })}
          onClose={() => setTrackPicker(null)}
        />
      )}
    </View>
  );
}

// ─── Styles ───────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000' },
  centeredOverlay: { ...StyleSheet.absoluteFillObject, alignItems: 'center', justifyContent: 'center' },

  // Controls overlay
  controls: { justifyContent: 'space-between' },

  // Top bar
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingTop: 16,
    paddingBottom: 8,
    backgroundColor: 'rgba(0,0,0,0.4)',
  },
  channelName: { flex: 1, color: '#fff', fontSize: 16, fontWeight: '600', marginRight: 12 },
  topBarBtn: { marginRight: 16 },
  topBarBtnText: { color: '#fff', fontSize: 13, fontWeight: '600', opacity: 0.85 },
  closeBtn: { color: '#fff', fontSize: 22 },

  // Center controls
  center: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 32,
  },
  seekBtn: { color: '#fff', fontSize: 14, fontWeight: '600' },
  playBtn: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: 'rgba(255,255,255,0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  playBtnText: { color: '#fff', fontSize: 22 },

  // Bottom bar
  bottomBar: {
    paddingHorizontal: 20,
    paddingBottom: 16,
    paddingTop: 8,
    backgroundColor: 'rgba(0,0,0,0.4)',
    gap: 10,
  },

  // Progress
  progressRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  timeText: { color: '#ccc', fontSize: 11, minWidth: 40, textAlign: 'center' },
  progressTrack: {
    flex: 1,
    height: 3,
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressFill: { height: '100%', backgroundColor: '#fff' },

  // Controls row (volume + track buttons)
  controlsRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  trackIcon: { color: '#fff', fontSize: 13, fontWeight: '600' },
  trackBtn: { paddingHorizontal: 4 },

  // Volume
  volumeTrack: {
    flex: 1,
    height: 3,
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 2,
    maxWidth: 120,
    position: 'relative',
  },
  volumeFill: { height: '100%', backgroundColor: '#fff', borderRadius: 2 },
  volumeThumb: {
    position: 'absolute',
    top: -5,
    marginLeft: -6,
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: '#fff',
  },

  // Error
  errorText: { color: '#ff4444', fontSize: 14, textAlign: 'center', marginBottom: 12 },
  retryBtn: {
    borderWidth: 1,
    borderColor: '#fff',
    borderRadius: 6,
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  retryText: { color: '#fff', fontSize: 14 },

  // Track picker modal
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.6)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  pickerSheet: {
    backgroundColor: '#1c1c1e',
    borderRadius: 12,
    padding: 16,
    minWidth: 220,
    maxHeight: 320,
  },
  pickerTitle: { color: '#fff', fontSize: 16, fontWeight: '700', marginBottom: 12 },
  pickerItem: { paddingVertical: 10 },
  pickerItemText: { color: '#ccc', fontSize: 14 },
  pickerItemSelected: { color: '#fff', fontWeight: '600' },
});
