import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import {
  Alert,
  Image,
  Modal,
  SectionList,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import DraggableFlatList, { RenderItemParams, ScaleDecorator } from 'react-native-draggable-flatlist';
import { usePlaylists, useUpdatePlaylist, useDeletePlaylist } from '../hooks/usePlaylists';
import { useChannels } from '../hooks/useChannels';
import { useProviderStore } from '../store/providerStore';
import { useProviders } from '../hooks/useProviders';
import { useTheme } from '../theme/useTheme';
import type { RootStackScreenProps } from '../navigation/types';
import type { Channel, Playlist } from '../specs/NativeMiPTVCore';

// ── Add channels picker modal ─────────────────────────────────────────────────

type ChannelPickerProps = {
  visible: boolean;
  allChannels: Channel[];
  existingIds: Set<string>;
  onAdd: (ch: Channel) => void;
  onClose: () => void;
  bgColor: string;
  surfaceColor: string;
  borderColor: string;
  textColor: string;
  secondaryColor: string;
  primaryColor: string;
};

function ChannelPickerModal({
  visible,
  allChannels,
  existingIds,
  onAdd,
  onClose,
  bgColor,
  borderColor,
  textColor,
  secondaryColor,
  primaryColor,
}: ChannelPickerProps) {
  const available = useMemo(
    () => allChannels.filter(ch => !existingIds.has(ch.id)),
    [allChannels, existingIds],
  );

  // Group by category
  type Section = { title: string; data: Channel[] };
  const sections = useMemo<Section[]>(() => {
    const map = new Map<string, Channel[]>();
    available.forEach(ch => {
      const g = ch.group || 'Other';
      const arr = map.get(g);
      if (arr) {
        arr.push(ch);
      } else {
        map.set(g, [ch]);
      }
    });
    return Array.from(map.entries())
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([title, data]) => ({ title, data }));
  }, [available]);

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={pickerStyles.overlay}>
        <View style={[pickerStyles.sheet, { backgroundColor: bgColor, borderTopColor: borderColor }]}>
          <View style={[pickerStyles.header, { borderColor }]}>
            <Text style={[pickerStyles.title, { color: textColor }]}>Add Channel</Text>
            <TouchableOpacity onPress={onClose} hitSlop={12}>
              <Text style={[pickerStyles.close, { color: primaryColor }]}>Done</Text>
            </TouchableOpacity>
          </View>
          <SectionList
            sections={sections}
            keyExtractor={item => item.id}
            stickySectionHeadersEnabled
            renderSectionHeader={({ section }) => (
              <View style={[pickerStyles.sectionHeader, { backgroundColor: bgColor }]}>
                <Text style={[pickerStyles.sectionTitle, { color: secondaryColor }]}>{section.title}</Text>
              </View>
            )}
            renderItem={({ item }) => (
              <TouchableOpacity
                style={[pickerStyles.row, { borderColor }]}
                onPress={() => onAdd(item)}
              >
                {item.logoUrl ? (
                  <Image source={{ uri: item.logoUrl }} style={pickerStyles.logo} resizeMode="contain" />
                ) : (
                  <View style={[pickerStyles.logoPlaceholder, { borderColor }]}>
                    <Text style={[pickerStyles.logoInitial, { color: secondaryColor }]}>
                      {item.name.charAt(0).toUpperCase()}
                    </Text>
                  </View>
                )}
                <Text style={[pickerStyles.channelName, { color: textColor }]} numberOfLines={1}>
                  {item.name}
                </Text>
                <Text style={[pickerStyles.addIcon, { color: primaryColor }]}>+</Text>
              </TouchableOpacity>
            )}
          />
        </View>
      </View>
    </Modal>
  );
}

const pickerStyles = StyleSheet.create({
  overlay: { flex: 1, justifyContent: 'flex-end', backgroundColor: 'rgba(0,0,0,0.4)' },
  sheet: { height: '75%', borderTopWidth: 1, borderTopLeftRadius: 16, borderTopRightRadius: 16 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 16, paddingVertical: 14, borderBottomWidth: StyleSheet.hairlineWidth },
  title: { fontSize: 17, fontWeight: '700' },
  close: { fontSize: 15, fontWeight: '600' },
  sectionHeader: { paddingHorizontal: 16, paddingVertical: 6 },
  sectionTitle: { fontSize: 11, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 0.5 },
  row: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, paddingVertical: 10, borderBottomWidth: StyleSheet.hairlineWidth },
  logo: { width: 40, height: 28, marginRight: 12, borderRadius: 4 },
  logoPlaceholder: { width: 40, height: 28, marginRight: 12, borderRadius: 4, borderWidth: 1, alignItems: 'center', justifyContent: 'center' },
  logoInitial: { fontSize: 14, fontWeight: '700' },
  channelName: { flex: 1, fontSize: 14 },
  addIcon: { fontSize: 22, fontWeight: '300', marginLeft: 8 },
});

// ── Main screen ───────────────────────────────────────────────────────────────

export function PlaylistDetailScreen({ route, navigation }: RootStackScreenProps<'PlaylistDetail'>) {
  const { playlistId, name: initialName } = route.params;
  const theme = useTheme();

  const { data: rawPlaylists } = usePlaylists();
  const playlists = useMemo<Playlist[]>(() => rawPlaylists ?? [], [rawPlaylists]);
  const playlist = useMemo(() => playlists.find(p => p.id === playlistId), [playlists, playlistId]);

  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const providerId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: rawChannels } = useChannels(providerId);
  const allChannels = useMemo<Channel[]>(() => rawChannels ?? [], [rawChannels]);

  const updatePlaylist = useUpdatePlaylist();
  const deletePlaylist = useDeletePlaylist();

  // Local state for editable channel list and name
  const [channels, setChannels] = useState<Channel[]>([]);
  const [name, setName] = useState(initialName);
  const [editingName, setEditingName] = useState(false);
  const [showPicker, setShowPicker] = useState(false);
  const nameRef = useRef(initialName);

  // Sync channels from playlist whenever playlists reload
  useEffect(() => {
    if (!playlist) { return; }
    const resolved = playlist.channelIds
      .map(id => allChannels.find(ch => ch.id === id))
      .filter((ch): ch is Channel => ch !== undefined);
    setChannels(resolved);
  }, [playlist, allChannels]);

  const existingIds = useMemo(() => new Set(channels.map(ch => ch.id)), [channels]);

  const save = useCallback((nextChannels: Channel[], nextName?: string) => {
    if (!playlist) { return; }
    updatePlaylist.mutate({
      ...playlist,
      name: nextName ?? nameRef.current,
      channelIds: nextChannels.map(ch => ch.id),
    });
  }, [playlist, updatePlaylist]);

  const handleNameCommit = useCallback(() => {
    setEditingName(false);
    const trimmed = name.trim();
    if (trimmed && trimmed !== nameRef.current) {
      nameRef.current = trimmed;
      navigation.setParams({ name: trimmed });
      save(channels, trimmed);
    }
  }, [name, channels, save, navigation]);

  const handleReorder = useCallback(({ data }: { data: Channel[] }) => {
    setChannels(data);
    save(data);
  }, [save]);

  const handleAddChannel = useCallback((ch: Channel) => {
    const next = [...channels, ch];
    setChannels(next);
    save(next);
  }, [channels, save]);

  const handleRemoveChannel = useCallback((channelId: string) => {
    const next = channels.filter(ch => ch.id !== channelId);
    setChannels(next);
    save(next);
  }, [channels, save]);

  const handleDeletePlaylist = useCallback(() => {
    Alert.alert(
      'Delete playlist',
      `Delete "${nameRef.current}"?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => {
            deletePlaylist.mutate(playlistId);
            navigation.goBack();
          },
        },
      ],
    );
  }, [deletePlaylist, playlistId, navigation]);

  const { colors, radius, fontSize: fs } = theme;

  const renderItem = useCallback(({ item, drag, isActive }: RenderItemParams<Channel>) => (
    <ScaleDecorator>
      <View style={[styles.row, { borderBottomColor: colors.border, backgroundColor: isActive ? colors.surfaceVariant : colors.background }]}>
        <TouchableOpacity onLongPress={drag} hitSlop={8} style={styles.dragHandle}>
          <Text style={[styles.dragIcon, { color: colors.textDisabled }]}>☰</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.rowContent}
          onPress={() => navigation.navigate('Player', { channelId: item.id, streamUrl: item.streamUrl, channelName: item.name })}
        >
          {item.logoUrl ? (
            <Image source={{ uri: item.logoUrl }} style={styles.logo} resizeMode="contain" />
          ) : (
            <View style={[styles.logoPlaceholder, { backgroundColor: colors.surface }]}>
              <Text style={[styles.logoInitial, { color: colors.textSecondary }]}>
                {item.name.charAt(0).toUpperCase()}
              </Text>
            </View>
          )}
          <View style={styles.info}>
            <Text style={[styles.channelName, { color: colors.text, fontSize: fs.md }]} numberOfLines={1}>
              {item.name}
            </Text>
            <Text style={[styles.group, { color: colors.textSecondary }]} numberOfLines={1}>
              {item.group}
            </Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => handleRemoveChannel(item.id)} hitSlop={12} style={styles.removeBtn}>
          <Text style={[styles.removeIcon, { color: colors.error }]}>✕</Text>
        </TouchableOpacity>
      </View>
    </ScaleDecorator>
  ), [colors, fs, navigation, handleRemoveChannel]);

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      {/* Editable playlist name header */}
      <View style={[styles.nameHeader, { borderBottomColor: colors.border, backgroundColor: colors.surface }]}>
        {editingName ? (
          <TextInput
            style={[styles.nameInput, { color: colors.text, borderColor: colors.border }]}
            value={name}
            onChangeText={setName}
            autoFocus
            returnKeyType="done"
            onBlur={handleNameCommit}
            onSubmitEditing={handleNameCommit}
          />
        ) : (
          <TouchableOpacity onPress={() => setEditingName(true)} style={styles.nameRow}>
            <Text style={[styles.nameText, { color: colors.text }]} numberOfLines={1}>{name}</Text>
            <Text style={[styles.editHint, { color: colors.textSecondary }]}>✏</Text>
          </TouchableOpacity>
        )}
        <TouchableOpacity onPress={handleDeletePlaylist} hitSlop={12} style={styles.deleteBtn}>
          <Text style={[styles.deleteBtnText, { color: colors.error }]}>Delete</Text>
        </TouchableOpacity>
      </View>

      {/* Channel list with drag-to-reorder */}
      {channels.length === 0 ? (
        <View style={styles.empty}>
          <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
            No channels yet. Tap + to add some.
          </Text>
        </View>
      ) : (
        <DraggableFlatList
          data={channels}
          keyExtractor={ch => ch.id}
          onDragEnd={handleReorder}
          renderItem={renderItem}
        />
      )}

      {/* Add channels FAB */}
      <TouchableOpacity
        style={[styles.fab, { backgroundColor: colors.primary, borderRadius: radius.full }]}
        onPress={() => setShowPicker(true)}
        activeOpacity={0.8}
      >
        <Text style={styles.fabText}>+</Text>
      </TouchableOpacity>

      {/* Channel picker bottom sheet */}
      <ChannelPickerModal
        visible={showPicker}
        allChannels={allChannels}
        existingIds={existingIds}
        onAdd={ch => { handleAddChannel(ch); }}
        onClose={() => setShowPicker(false)}
        bgColor={colors.background}
        surfaceColor={colors.surface}
        borderColor={colors.border}
        textColor={colors.text}
        secondaryColor={colors.textSecondary}
        primaryColor={colors.primary}
      />
    </View>
  );
}

// ── Styles ────────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  container: { flex: 1 },

  // Name header
  nameHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
    gap: 8,
  },
  nameRow: { flex: 1, flexDirection: 'row', alignItems: 'center', gap: 6 },
  nameText: { fontSize: 18, fontWeight: '700', flex: 1 },
  editHint: { fontSize: 14 },
  nameInput: {
    flex: 1,
    fontSize: 18,
    fontWeight: '700',
    borderBottomWidth: 1,
    paddingVertical: 2,
  },
  deleteBtn: { paddingHorizontal: 4 },
  deleteBtnText: { fontSize: 14, fontWeight: '500' },

  // Channel rows
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: StyleSheet.hairlineWidth,
    paddingLeft: 4,
    paddingRight: 8,
  },
  dragHandle: { padding: 12 },
  dragIcon: { fontSize: 18 },
  rowContent: { flex: 1, flexDirection: 'row', alignItems: 'center', paddingVertical: 10 },
  logo: { width: 40, height: 28, marginRight: 12, borderRadius: 4 },
  logoPlaceholder: {
    width: 40,
    height: 28,
    marginRight: 12,
    borderRadius: 4,
    alignItems: 'center',
    justifyContent: 'center',
  },
  logoInitial: { fontSize: 16, fontWeight: '700' },
  info: { flex: 1 },
  channelName: { fontWeight: '500' },
  group: { fontSize: 12, marginTop: 1 },
  removeBtn: { padding: 8 },
  removeIcon: { fontSize: 16, fontWeight: '600' },

  // Empty state
  empty: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32 },
  emptyText: { fontSize: 14, textAlign: 'center' },

  // FAB
  fab: {
    position: 'absolute',
    right: 16,
    bottom: 16,
    width: 52,
    height: 52,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 4,
  },
  fabText: { color: '#fff', fontSize: 28, lineHeight: 32 },
});
