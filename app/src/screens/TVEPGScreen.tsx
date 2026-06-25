import React, { useMemo, useState } from 'react';
import {
  ActivityIndicator,
  FlatList,
  Modal,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { TVFocusGuideView } from 'react-native';
import { useChannels } from '../hooks/useChannels';
import { useProviders } from '../hooks/useProviders';
import { useEpgForChannel, useAutoSyncEpg } from '../hooks/useEpg';
import { useProviderStore } from '../store/providerStore';
import { TVFocusable } from '../components/TVFocusable';
import { useTVNavigation } from '../hooks/useTVNavigation';
import type { Channel, EpgEntry } from '../specs/NativeMiPTVCore';
import type { TabScreenProps } from '../navigation/types';

const ROW_H = 80;
const CHANNEL_W = 200;
const CELL_MINS = 90; // each cell represents 1.5 hours
const CELL_W = 280;

function formatHHMM(ts: number): string {
  const d = new Date(ts * 1000);
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`;
}

type ProgramCellProps = {
  entry: EpgEntry;
  onPress: (entry: EpgEntry) => void;
  hasTVPreferredFocus?: boolean;
};

function ProgramCell({ entry, onPress, hasTVPreferredFocus }: ProgramCellProps) {
  return (
    <TVFocusable
      style={styles.cell}
      onPress={() => onPress(entry)}
      hasTVPreferredFocus={hasTVPreferredFocus}
    >
      <Text style={styles.cellTime}>{formatHHMM(entry.start)}</Text>
      <Text style={styles.cellTitle} numberOfLines={2}>{entry.title}</Text>
    </TVFocusable>
  );
}

type ChannelRowProps = {
  channel: Channel;
  nowSecs: number;
  onProgramSelect: (entry: EpgEntry) => void;
  firstFocused: boolean;
};

function ChannelRow({ channel, nowSecs, onProgramSelect, firstFocused }: ChannelRowProps) {
  const windowStart = Math.floor(nowSecs / 3600) * 3600;
  const windowEnd = windowStart + CELL_MINS * 60 * 4;
  const { data: programmes } = useEpgForChannel(channel.id, windowStart, windowEnd);
  const safeProgrammes: EpgEntry[] = useMemo(() => programmes ?? [], [programmes]);

  return (
    <View style={styles.channelRow}>
      <View style={styles.channelLabel}>
        <Text style={styles.channelName} numberOfLines={2}>{channel.name}</Text>
      </View>
      {safeProgrammes.length === 0 ? (
        <View style={[styles.cell, styles.noData]}>
          <Text style={styles.noDataText}>No EPG data</Text>
        </View>
      ) : (
        <FlatList
          data={safeProgrammes}
          horizontal
          showsHorizontalScrollIndicator={false}
          keyExtractor={(item) => `${item.channelId}-${item.start}`}
          renderItem={({ item, index }) => (
            <ProgramCell
              entry={item}
              onPress={onProgramSelect}
              hasTVPreferredFocus={firstFocused && index === 0}
            />
          )}
        />
      )}
    </View>
  );
}

type DetailModalProps = {
  entry: EpgEntry | null;
  onClose: () => void;
};

function DetailModal({ entry, onClose }: DetailModalProps) {
  useTVNavigation({ menu: onClose, select: onClose });

  return (
    <Modal visible={entry !== null} transparent animationType="fade" onRequestClose={onClose}>
      <View style={styles.modalBackdrop}>
        <TVFocusable style={styles.modalCard} onPress={onClose} hasTVPreferredFocus>
          {entry && (
            <>
              <Text style={styles.modalTitle}>{entry.title}</Text>
              <Text style={styles.modalTime}>
                {formatHHMM(entry.start)} – {formatHHMM(entry.end)}
                {entry.category ? `  ·  ${entry.category}` : ''}
              </Text>
              {entry.description && (
                <Text style={styles.modalDesc}>{entry.description}</Text>
              )}
              <Text style={styles.modalHint}>Press select or menu to close</Text>
            </>
          )}
        </TVFocusable>
      </View>
    </Modal>
  );
}

export function TVEPGScreen(_props: TabScreenProps<'EPGTab'>) {
  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const providerId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: rawChannels, isLoading } = useChannels(providerId);
  const channels = useMemo<Channel[]>(() => rawChannels ?? [], [rawChannels]);
  const [selectedEntry, setSelectedEntry] = useState<EpgEntry | null>(null);
  const nowSecs = Math.floor(Date.now() / 1000);

  useAutoSyncEpg(providers);

  if (isLoading) {
    return (
      <View style={styles.loading}>
        <ActivityIndicator size="large" color="#007AFF" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Text style={styles.heading}>TV Guide</Text>
      <TVFocusGuideView autoFocus style={styles.grid}>
        <ScrollView>
          {channels.map((ch, idx) => (
            <ChannelRow
              key={ch.id}
              channel={ch}
              nowSecs={nowSecs}
              onProgramSelect={setSelectedEntry}
              firstFocused={idx === 0}
            />
          ))}
        </ScrollView>
      </TVFocusGuideView>
      <DetailModal entry={selectedEntry} onClose={() => setSelectedEntry(null)} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a18' },
  loading: { flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: '#0a0a18' },
  heading: { color: '#fff', fontSize: 28, fontWeight: '700', padding: 20, paddingBottom: 8 },

  grid: { flex: 1 },

  channelRow: {
    height: ROW_H,
    flexDirection: 'row',
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: '#333',
  },
  channelLabel: {
    width: CHANNEL_W,
    justifyContent: 'center',
    paddingHorizontal: 12,
    backgroundColor: '#111',
    borderRightWidth: 1,
    borderRightColor: '#333',
  },
  channelName: { color: '#fff', fontSize: 15, fontWeight: '500' },

  cell: {
    width: CELL_W,
    height: ROW_H,
    justifyContent: 'center',
    paddingHorizontal: 12,
    borderRightWidth: StyleSheet.hairlineWidth,
    borderRightColor: '#333',
    backgroundColor: '#12122a',
  },
  noData: { backgroundColor: '#0d0d1a' },
  noDataText: { color: '#444', fontSize: 13 },
  cellTime: { color: '#007AFF', fontSize: 12, fontWeight: '600', marginBottom: 4 },
  cellTitle: { color: '#e0e0e0', fontSize: 15, fontWeight: '500' },

  // Modal
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.8)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  modalCard: {
    backgroundColor: '#1a1a2e',
    borderRadius: 16,
    padding: 40,
    maxWidth: 640,
    width: '80%',
  },
  modalTitle: { color: '#fff', fontSize: 28, fontWeight: '700', marginBottom: 8 },
  modalTime: { color: '#007AFF', fontSize: 16, fontWeight: '600', marginBottom: 16 },
  modalDesc: { color: '#ccc', fontSize: 16, lineHeight: 24, marginBottom: 24 },
  modalHint: { color: '#555', fontSize: 13, textAlign: 'center' },
});
