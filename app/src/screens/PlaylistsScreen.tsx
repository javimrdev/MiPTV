import React, { useCallback, useMemo, useState } from 'react';
import {
  Alert,
  FlatList,
  Image,
  Modal,
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import type { Playlist } from '../specs/NativeMiPTVCore';
import { useFavouritesStore } from '../store/favouritesStore';
import { usePlaylists, useCreatePlaylist, useDeletePlaylist } from '../hooks/usePlaylists';
import { useProviderStore } from '../store/providerStore';
import { useProviders } from '../hooks/useProviders';
import { useChannels } from '../hooks/useChannels';
import { FavouriteButton } from '../components/FavouriteButton';
import { EmptyState } from '../components/EmptyState';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../theme/useTheme';
import type { TabScreenProps } from '../navigation/types';
import type { Channel } from '../specs/NativeMiPTVCore';

// ── Create playlist modal ─────────────────────────────────────────────────────

type CreateModalProps = {
  visible: boolean;
  onConfirm: (name: string) => void;
  onClose: () => void;
  borderColor: string;
  bgColor: string;
  textColor: string;
  placeholderColor: string;
  borderRadius: number;
  primaryColor: string;
};

function CreatePlaylistModal({
  visible,
  onConfirm,
  onClose,
  borderColor,
  bgColor,
  textColor,
  placeholderColor,
  borderRadius,
  primaryColor,
}: CreateModalProps) {
  const [name, setName] = useState('');

  const handleConfirm = useCallback(() => {
    const trimmed = name.trim();
    if (!trimmed) { return; }
    onConfirm(trimmed);
    setName('');
  }, [name, onConfirm]);

  const handleClose = useCallback(() => {
    setName('');
    onClose();
  }, [onClose]);

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={handleClose}>
      <Pressable style={styles.modalBackdrop} onPress={handleClose}>
        <View
          style={[styles.modalCard, { backgroundColor: bgColor, borderColor, borderRadius }]}
          onStartShouldSetResponder={() => true}
        >
          <Text style={[styles.modalTitle, { color: textColor }]}>New Playlist</Text>
          <TextInput
            style={[styles.modalInput, { borderColor, color: textColor }]}
            placeholder="Playlist name"
            placeholderTextColor={placeholderColor}
            value={name}
            onChangeText={setName}
            autoFocus
            returnKeyType="done"
            onSubmitEditing={handleConfirm}
          />
          <View style={styles.modalButtons}>
            <TouchableOpacity style={styles.modalBtn} onPress={handleClose}>
              <Text style={[styles.modalBtnText, { color: placeholderColor }]}>Cancel</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.modalBtn, styles.modalBtnPrimary, { backgroundColor: primaryColor }]}
              onPress={handleConfirm}
            >
              <Text style={styles.modalBtnTextPrimary}>Create</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Pressable>
    </Modal>
  );
}

// ── Main screen ───────────────────────────────────────────────────────────────

export function PlaylistsScreen({ navigation }: TabScreenProps<'PlaylistsTab'>) {
  const theme = useTheme();
  const { top } = useSafeAreaInsets();
  const favouriteIds = useFavouritesStore(s => s.favouriteIds);
  const { data: rawPlaylists } = usePlaylists();
  const playlists: Playlist[] = rawPlaylists ?? [];
  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const selectedProviderId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: rawChannels } = useChannels(selectedProviderId);
  const allChannels = useMemo<Channel[]>(() => rawChannels ?? [], [rawChannels]);

  const createPlaylist = useCreatePlaylist();
  const deletePlaylist = useDeletePlaylist();

  const [showCreate, setShowCreate] = useState(false);

  const favouriteChannels = useMemo(
    () => allChannels.filter((ch: Channel) => favouriteIds.has(ch.id)),
    [allChannels, favouriteIds],
  );

  const handleCreate = useCallback((name: string) => {
    createPlaylist.mutate({
      id: `pl_${Date.now()}`,
      name,
      channelIds: [],
      createdAt: Math.floor(Date.now() / 1000),
      isFavorites: false,
    });
    setShowCreate(false);
  }, [createPlaylist]);

  const handleDelete = useCallback((pl: Playlist) => {
    Alert.alert(
      'Delete playlist',
      `Delete "${pl.name}"?`,
      [
        { text: 'Cancel', style: 'cancel' },
        { text: 'Delete', style: 'destructive', onPress: () => deletePlaylist.mutate(pl.id) },
      ],
    );
  }, [deletePlaylist]);

  const { colors, radius } = theme;

  // ── Render ──────────────────────────────────────────────────────────────────

  if (providers.length === 0) {
    return (
      <EmptyState
        title="No providers"
        message="Add a provider to start creating playlists."
        actionLabel="Add Provider"
        onAction={() => navigation.navigate('ProviderAdd')}
      />
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.background, paddingTop: top }]}>
      <FlatList
        data={[
          // Favourites section header + channels
          ...(favouriteChannels.length > 0 ? [{ type: 'header' as const, title: 'Favourites ★', id: '__fav_header' }, ...favouriteChannels.map(ch => ({ type: 'channel' as const, ch, playlistId: '__fav' }))] : []),
          // Custom playlists
          ...playlists.filter(pl => !pl.isFavorites).flatMap(pl => [
            { type: 'playlist-header' as const, pl, id: `h_${pl.id}` },
          ]),
        ]}
        keyExtractor={item => ('id' in item && item.id ? item.id : ('ch' in item ? item.ch.id : ''))}
        ListEmptyComponent={
          <View style={styles.emptyInner}>
            <Text style={[styles.emptyText, { color: colors.textSecondary }]}>
              No playlists yet. Tap + to create one.
            </Text>
          </View>
        }
        renderItem={({ item }) => {
          if (item.type === 'header') {
            return (
              <View style={[styles.sectionHeader, { backgroundColor: colors.surfaceVariant }]}>
                <Text style={[styles.sectionTitle, { color: colors.textSecondary }]}>{item.title}</Text>
              </View>
            );
          }
          if (item.type === 'channel') {
            const ch = item.ch;
            return (
              <TouchableOpacity
                style={[styles.row, { borderBottomColor: colors.border }]}
                onPress={() => navigation.navigate('Player', { channelId: ch.id, streamUrl: ch.streamUrl, channelName: ch.name })}
              >
                {ch.logoUrl ? (
                  <Image source={{ uri: ch.logoUrl }} style={styles.logo} resizeMode="contain" />
                ) : (
                  <View style={[styles.logoPlaceholder, { backgroundColor: colors.surface }]}>
                    <Text style={[styles.logoInitial, { color: colors.textSecondary }]}>
                      {ch.name.charAt(0).toUpperCase()}
                    </Text>
                  </View>
                )}
                <View style={styles.info}>
                  <Text style={[styles.name, { color: colors.text }]} numberOfLines={1}>{ch.name}</Text>
                  <Text style={[styles.group, { color: colors.textSecondary }]} numberOfLines={1}>{ch.group}</Text>
                </View>
                <FavouriteButton channelId={ch.id} size={18} />
              </TouchableOpacity>
            );
          }
          if (item.type === 'playlist-header') {
            const pl = item.pl;
            const count = pl.channelIds.length;
            return (
              <TouchableOpacity
                style={[styles.playlistRow, { borderBottomColor: colors.border }]}
                onPress={() => navigation.navigate('PlaylistDetail', { playlistId: pl.id, name: pl.name })}
              >
                <View style={[styles.playlistIcon, { backgroundColor: colors.primary }]}>
                  <Text style={styles.playlistIconText}>▶</Text>
                </View>
                <View style={styles.info}>
                  <Text style={[styles.name, { color: colors.text }]} numberOfLines={1}>{pl.name}</Text>
                  <Text style={[styles.group, { color: colors.textSecondary }]}>{count} channel{count !== 1 ? 's' : ''}</Text>
                </View>
                <TouchableOpacity onPress={() => handleDelete(pl)} hitSlop={12} style={styles.deleteBtn}>
                  <Text style={[styles.deleteBtnText, { color: colors.error }]}>✕</Text>
                </TouchableOpacity>
              </TouchableOpacity>
            );
          }
          return null;
        }}
      />

      {/* Create playlist FAB */}
      <TouchableOpacity
        style={[styles.fab, { backgroundColor: colors.primary, borderRadius: radius.full }]}
        onPress={() => setShowCreate(true)}
        activeOpacity={0.8}
      >
        <Text style={styles.fabText}>+</Text>
      </TouchableOpacity>

      <CreatePlaylistModal
        visible={showCreate}
        onConfirm={handleCreate}
        onClose={() => setShowCreate(false)}
        borderColor={colors.border}
        bgColor={colors.surface}
        textColor={colors.text}
        placeholderColor={colors.textSecondary}
        borderRadius={radius.lg}
        primaryColor={colors.primary}
      />
    </View>
  );
}

// ── Styles ────────────────────────────────────────────────────────────────────

const styles = StyleSheet.create({
  container: { flex: 1 },
  emptyInner: { padding: 32, alignItems: 'center' },
  emptyText: { fontSize: 14, textAlign: 'center' },

  sectionHeader: { paddingHorizontal: 16, paddingVertical: 8 },
  sectionTitle: { fontSize: 12, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 0.5 },

  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  playlistRow: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  playlistIcon: {
    width: 40,
    height: 40,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  playlistIconText: { color: '#fff', fontSize: 16 },

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
  name: { fontSize: 15, fontWeight: '500' },
  group: { fontSize: 12, marginTop: 1 },
  deleteBtn: { padding: 8 },
  deleteBtnText: { fontSize: 16, fontWeight: '600' },

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

  // Create modal
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  modalCard: {
    borderWidth: StyleSheet.hairlineWidth,
    padding: 20,
    gap: 12,
  },
  modalTitle: { fontSize: 17, fontWeight: '700' },
  modalInput: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 15,
  },
  modalButtons: { flexDirection: 'row', justifyContent: 'flex-end', gap: 8 },
  modalBtn: { paddingHorizontal: 16, paddingVertical: 10, borderRadius: 8 },
  modalBtnPrimary: {},
  modalBtnText: { fontSize: 15 },
  modalBtnTextPrimary: { fontSize: 15, color: '#fff', fontWeight: '600' },
});
