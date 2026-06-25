import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  Image,
  Modal,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useChannels } from '../hooks/useChannels';
import { useProviders } from '../hooks/useProviders';
import { useEpgForChannel, useAutoSyncEpg } from '../hooks/useEpg';
import { useProviderStore } from '../store/providerStore';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../theme/useTheme';
import { TVEPGScreen } from './TVEPGScreen';
import type { TabScreenProps } from '../navigation/types';
import type { EpgEntry, Channel } from '../specs/NativeMiPTVCore';

// ── Layout constants ──────────────────────────────────────────────────────────

const LABEL_W = 100;
const HOUR_W = 120; // px per hour
const ROW_H = 56;
const HEADER_H = 40;
const MIN_PROGRAM_W = 8;
const RANGE_HOURS = 24;
const TOTAL_W = RANGE_HOURS * HOUR_W;

// ── Helpers ───────────────────────────────────────────────────────────────────

function todayMidnightUnix(): number {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return Math.floor(d.getTime() / 1000);
}

function formatHHMM(ts: number): string {
  const d = new Date(ts * 1000);
  const hh = String(d.getHours()).padStart(2, '0');
  const mm = String(d.getMinutes()).padStart(2, '0');
  return `${hh}:${mm}`;
}

function formatDateHHMM(ts: number): string {
  const d = new Date(ts * 1000);
  const month = d.toLocaleString('default', { month: 'short' });
  const day = d.getDate();
  const hh = String(d.getHours()).padStart(2, '0');
  const mm = String(d.getMinutes()).padStart(2, '0');
  return `${month} ${day}  ${hh}:${mm}`;
}

function tsToX(ts: number, rangeStart: number): number {
  return ((ts - rangeStart) / 3600) * HOUR_W;
}

// ── Sub-components ────────────────────────────────────────────────────────────

type ProgramBoxProps = {
  program: EpgEntry;
  rangeStart: number;
  onPress: (program: EpgEntry) => void;
  borderColor: string;
  bgColor: string;
  textColor: string;
  secondaryColor: string;
};

function ProgramBox({
  program,
  rangeStart,
  onPress,
  borderColor,
  bgColor,
  textColor,
  secondaryColor,
}: ProgramBoxProps) {
  const left = Math.max(0, tsToX(program.start, rangeStart));
  const right = tsToX(program.end, rangeStart);
  const width = Math.max(MIN_PROGRAM_W, right - left - 2);

  return (
    <TouchableOpacity
      style={[styles.programBox, { left, width, borderColor, backgroundColor: bgColor }]}
      onPress={() => onPress(program)}
      activeOpacity={0.75}
    >
      <Text style={[styles.programTitle, { color: textColor }]} numberOfLines={1}>
        {program.title}
      </Text>
      <Text style={[styles.programTime, { color: secondaryColor }]} numberOfLines={1}>
        {formatHHMM(program.start)}–{formatHHMM(program.end)}
      </Text>
    </TouchableOpacity>
  );
}

type EpgRowProps = {
  channel: Channel;
  rangeStart: number;
  rangeEnd: number;
  nowX: number;
  scrollX: number;
  scrollRef: (ref: ScrollView | null) => void;
  onScroll: (x: number) => void;
  onProgramPress: (program: EpgEntry) => void;
  borderColor: string;
  surfaceColor: string;
  textColor: string;
  secondaryColor: string;
  primaryColor: string;
};

function EpgRow({
  channel,
  rangeStart,
  rangeEnd,
  nowX,
  scrollRef,
  onScroll,
  onProgramPress,
  borderColor,
  surfaceColor,
  textColor,
  secondaryColor,
  primaryColor,
}: EpgRowProps) {
  const { data: programs } = useEpgForChannel(channel.id, rangeStart, rangeEnd);
  const safePrograms: EpgEntry[] = programs ?? [];

  return (
    <View style={[styles.row, { borderColor }]}>
      {/* Channel label */}
      <View style={[styles.label, { borderColor, backgroundColor: surfaceColor }]}>
        {channel.logoUrl ? (
          <Image source={{ uri: channel.logoUrl }} style={styles.logo} resizeMode="contain" />
        ) : (
          <Text style={[styles.labelText, { color: textColor }]} numberOfLines={2}>
            {channel.name}
          </Text>
        )}
      </View>

      {/* Program timeline */}
      <ScrollView
        ref={scrollRef}
        horizontal
        scrollEventThrottle={16}
        showsHorizontalScrollIndicator={false}
        onScroll={({ nativeEvent }) => onScroll(nativeEvent.contentOffset.x)}
      >
        <View style={[styles.timelineContent, { width: TOTAL_W }]}>
          {/* Current time line */}
          {nowX > 0 && nowX < TOTAL_W && (
            <View style={[styles.nowLine, { left: nowX, backgroundColor: primaryColor }]} />
          )}

          {/* Program boxes */}
          {safePrograms.map(p => (
            <ProgramBox
              key={`${p.channelId}-${p.start}`}
              program={p}
              rangeStart={rangeStart}
              onPress={onProgramPress}
              borderColor={borderColor}
              bgColor={surfaceColor}
              textColor={textColor}
              secondaryColor={secondaryColor}
            />
          ))}
        </View>
      </ScrollView>
    </View>
  );
}

// ── Main screen ───────────────────────────────────────────────────────────────

export function EPGScreen(props: TabScreenProps<'EPGTab'>) {
  if (Platform.isTV) {
    return <TVEPGScreen {...props} />;
  }
  return <EPGScreenMobile {...props} />;
}

function EPGScreenMobile(_props: TabScreenProps<'EPGTab'>) {
  const theme = useTheme();
  const { top } = useSafeAreaInsets();
  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const selectedId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: channels = [], isLoading } = useChannels(selectedId);

  useAutoSyncEpg(providers);

  const rangeStart = useMemo(() => todayMidnightUnix(), []);
  const rangeEnd = rangeStart + RANGE_HOURS * 3600;

  const [nowX, setNowX] = useState(() => tsToX(Math.floor(Date.now() / 1000), rangeStart));
  const [selectedProgram, setSelectedProgram] = useState<EpgEntry | null>(null);

  // Update "now" marker every minute
  useEffect(() => {
    const timer = setInterval(() => {
      setNowX(tsToX(Math.floor(Date.now() / 1000), rangeStart));
    }, 60_000);
    return () => clearInterval(timer);
  }, [rangeStart]);

  // Scroll-sync refs
  const rowRefs = useRef<Map<string, ScrollView | null>>(new Map());
  const timeHeaderRef = useRef<ScrollView | null>(null);
  const isSyncing = useRef(false);
  const scrollXRef = useRef(0);

  const syncScroll = useCallback((x: number) => {
    if (isSyncing.current) { return; }
    isSyncing.current = true;
    scrollXRef.current = x;
    timeHeaderRef.current?.scrollTo({ x, animated: false });
    rowRefs.current.forEach(ref => ref?.scrollTo({ x, animated: false }));
    isSyncing.current = false;
  }, []);

  const scrollToNow = useCallback(() => {
    const x = Math.max(0, nowX - 80);
    scrollXRef.current = x;
    timeHeaderRef.current?.scrollTo({ x, animated: true });
    rowRefs.current.forEach(ref => ref?.scrollTo({ x, animated: true }));
  }, [nowX]);

  // Scroll to "now" when data loads
  const hasScrolledToNow = useRef(false);
  useEffect(() => {
    if (channels.length > 0 && !hasScrolledToNow.current) {
      hasScrolledToNow.current = true;
      // Small delay so layout settles
      setTimeout(scrollToNow, 200);
    }
  }, [channels.length, scrollToNow]);

  // Time axis slots (every 30 min)
  const timeSlots = useMemo(() => {
    const slots: number[] = [];
    for (let m = 0; m < RANGE_HOURS * 60; m += 30) {
      slots.push(rangeStart + m * 60);
    }
    return slots;
  }, [rangeStart]);

  const { colors, radius, fontSize: fs } = theme;

  // ── render ──────────────────────────────────────────────────────────────────

  if (isLoading) {
    return (
      <View style={[styles.centered, { backgroundColor: colors.background }]}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }

  if (channels.length === 0) {
    return (
      <View style={[styles.centered, { backgroundColor: colors.background }]}>
        <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
          No channels. Add a provider first.
        </Text>
      </View>
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.background, paddingTop: top }]}>
      {/* Time axis header */}
      <View style={[styles.header, { borderColor: colors.border, backgroundColor: colors.surface }]}>
        <View style={[styles.headerCorner, { borderColor: colors.border }]} />
        <ScrollView
          ref={timeHeaderRef}
          horizontal
          scrollEnabled={false}
          showsHorizontalScrollIndicator={false}
        >
          <View style={styles.timeSlotsRow}>
            {timeSlots.map(ts => {
              const isHour = new Date(ts * 1000).getMinutes() === 0;
              return (
                <View
                  key={ts}
                  style={[
                    styles.timeSlot,
                    {
                      width: HOUR_W / 2,
                      borderColor: colors.border,
                    },
                  ]}
                >
                  <Text
                    style={[
                      styles.timeLabel,
                      isHour ? styles.timeLabelHour : styles.timeLabelHalf,
                      {
                        color: isHour ? colors.text : colors.textSecondary,
                        fontSize: fs.xs,
                      },
                    ]}
                  >
                    {formatHHMM(ts)}
                  </Text>
                </View>
              );
            })}
          </View>
        </ScrollView>
      </View>

      {/* Channel rows */}
      <FlatList
        data={channels}
        keyExtractor={ch => ch.id}
        renderItem={({ item: channel }) => (
          <EpgRow
            channel={channel}
            rangeStart={rangeStart}
            rangeEnd={rangeEnd}
            nowX={nowX}
            scrollX={scrollXRef.current}
            scrollRef={ref => rowRefs.current.set(channel.id, ref)}
            onScroll={syncScroll}
            onProgramPress={setSelectedProgram}
            borderColor={colors.border}
            surfaceColor={colors.surface}
            textColor={colors.text}
            secondaryColor={colors.textSecondary}
            primaryColor={colors.primary}
          />
        )}
        showsVerticalScrollIndicator={false}
      />

      {/* Scroll to now button */}
      <TouchableOpacity
        style={[
          styles.nowButton,
          { backgroundColor: colors.primary, borderRadius: radius.full },
        ]}
        onPress={scrollToNow}
        activeOpacity={0.8}
      >
        <Text style={[styles.nowButtonText, { color: colors.primaryForeground }]}>Now</Text>
      </TouchableOpacity>

      {/* Program detail modal */}
      {selectedProgram && (
        <Modal
          visible
          transparent
          animationType="fade"
          onRequestClose={() => setSelectedProgram(null)}
        >
          <Pressable style={styles.modalBackdrop} onPress={() => setSelectedProgram(null)}>
            <View
              style={[
                styles.modalCard,
                {
                  backgroundColor: colors.surface,
                  borderRadius: radius.lg,
                  borderColor: colors.border,
                },
              ]}
              // Prevent backdrop tap from closing when tapping the card
              onStartShouldSetResponder={() => true}
            >
              <Text style={[styles.modalTitle, { color: colors.text, fontSize: fs.lg }]}>
                {selectedProgram.title}
              </Text>

              <Text style={[styles.modalTime, { color: colors.primary, fontSize: fs.sm }]}>
                {formatDateHHMM(selectedProgram.start)} – {formatHHMM(selectedProgram.end)}
              </Text>

              {selectedProgram.category ? (
                <View
                  style={[
                    styles.modalCategory,
                    { backgroundColor: colors.surfaceVariant, borderRadius: radius.sm },
                  ]}
                >
                  <Text style={[styles.modalCategoryText, { color: colors.textSecondary, fontSize: fs.xs }]}>
                    {selectedProgram.category}
                  </Text>
                </View>
              ) : null}

              {selectedProgram.description ? (
                <Text style={[styles.modalDesc, { color: colors.textSecondary, fontSize: fs.sm }]}>
                  {selectedProgram.description}
                </Text>
              ) : null}

              <TouchableOpacity
                style={[styles.modalClose, { borderColor: colors.border, borderRadius: radius.md }]}
                onPress={() => setSelectedProgram(null)}
                activeOpacity={0.7}
              >
                <Text style={[styles.modalCloseText, { color: colors.text }]}>Close</Text>
              </TouchableOpacity>
            </View>
          </Pressable>
        </Modal>
      )}
    </View>
  );
}

// ── Styles ────────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  container: { flex: 1 },
  centered: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  emptyText: { fontSize: 15 },

  // Time header
  header: {
    height: HEADER_H,
    flexDirection: 'row',
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  headerCorner: {
    width: LABEL_W,
    borderRightWidth: StyleSheet.hairlineWidth,
  },
  timeSlotsRow: { width: TOTAL_W, flexDirection: 'row' },
  timeSlot: {
    height: HEADER_H,
    borderLeftWidth: StyleSheet.hairlineWidth,
    paddingLeft: 4,
    justifyContent: 'center',
  },
  timeLabel: {},
  timeLabelHour: { fontWeight: '600' },
  timeLabelHalf: { fontWeight: '400' },

  // Channel row
  row: {
    height: ROW_H,
    flexDirection: 'row',
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  label: {
    width: LABEL_W,
    height: ROW_H,
    borderRightWidth: StyleSheet.hairlineWidth,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 6,
  },
  labelText: { fontSize: 11, textAlign: 'center' },
  logo: { width: 60, height: 36 },

  // Timeline
  timelineContent: { height: ROW_H, position: 'relative' },
  nowLine: { position: 'absolute', top: 0, bottom: 0, width: 2, zIndex: 10 },

  // Program box
  programBox: {
    position: 'absolute',
    top: 4,
    height: ROW_H - 8,
    borderWidth: StyleSheet.hairlineWidth,
    borderRadius: 4,
    paddingHorizontal: 6,
    paddingVertical: 3,
    justifyContent: 'center',
  },
  programTitle: { fontSize: 11, fontWeight: '500' },
  programTime: { fontSize: 10, marginTop: 1 },

  // Now button
  nowButton: {
    position: 'absolute',
    right: 16,
    bottom: 16,
    paddingHorizontal: 16,
    paddingVertical: 8,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  nowButtonText: { fontSize: 13, fontWeight: '600' },

  // Modal
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  modalCard: {
    borderWidth: StyleSheet.hairlineWidth,
    padding: 20,
    gap: 10,
  },
  modalTitle: { fontWeight: '700', lineHeight: 22 },
  modalTime: { fontWeight: '500' },
  modalCategory: { alignSelf: 'flex-start', paddingHorizontal: 8, paddingVertical: 3 },
  modalCategoryText: { fontWeight: '500' },
  modalDesc: { lineHeight: 20 },
  modalClose: {
    marginTop: 6,
    borderWidth: 1,
    paddingVertical: 10,
    alignItems: 'center',
  },
  modalCloseText: { fontSize: 14, fontWeight: '500' },
});
