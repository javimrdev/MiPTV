import React, { useCallback, useMemo, useState } from 'react';
import {
  Alert,
  FlatList,
  Image,
  Modal,
  Pressable,
  RefreshControl,
  SectionList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useChannels } from '../hooks/useChannels';
import { useProviderStore } from '../store/providerStore';
import { useProviders } from '../hooks/useProviders';
import { usePlaylists, useUpdatePlaylist } from '../hooks/usePlaylists';
import { LoadingView } from '../components/LoadingView';
import { FavouriteButton } from '../components/FavouriteButton';
import { EmptyState } from '../components/EmptyState';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTheme } from '../theme/useTheme';
import type { TabScreenProps } from '../navigation/types';
import type { Channel, Playlist } from '../specs/NativeMiPTVCore';

type Section = { title: string; data: Channel[] };

export function ChannelsScreen({ navigation }: TabScreenProps<'ChannelsTab'>) {
  const theme = useTheme();
  const { top } = useSafeAreaInsets();
  const { data: providers = [] } = useProviders();
  const { activeProviderId, setActiveProvider } = useProviderStore();

  const firstProvider = providers[0];
  const selectedProviderId = activeProviderId ?? firstProvider?.id ?? '';

  const { data: channels = [], isLoading, refetch, isRefetching } = useChannels(selectedProviderId);
  const { data: playlists = [] } = usePlaylists();
  const updatePlaylist = useUpdatePlaylist();

  const [longPressedChannel, setLongPressedChannel] = useState<Channel | null>(null);

  const tabTextUnselected = useMemo(() => ({ color: theme.colors.text }), [theme.colors.text]);

  const userPlaylists = useMemo(
    () => playlists.filter((pl: Playlist) => !pl.isFavorites),
    [playlists],
  );

  const handleAddToPlaylist = useCallback((playlist: Playlist) => {
    if (!longPressedChannel) { return; }
    if (playlist.channelIds.includes(longPressedChannel.id)) {
      Alert.alert('Already added', `"${longPressedChannel.name}" is already in "${playlist.name}".`);
      setLongPressedChannel(null);
      return;
    }
    updatePlaylist.mutate({
      ...playlist,
      channelIds: [...playlist.channelIds, longPressedChannel.id],
    });
    setLongPressedChannel(null);
  }, [longPressedChannel, updatePlaylist]);

  const sections = useMemo<Section[]>(() => {
    const map = new Map<string, Channel[]>();
    channels.forEach((ch: Channel) => {
      const group = ch.group || 'Uncategorized';
      const existing = map.get(group);
      if (existing) {
        existing.push(ch);
      } else {
        map.set(group, [ch]);
      }
    });
    return Array.from(map.entries())
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([title, data]) => ({ title, data }));
  }, [channels]);

  if (providers.length === 0) {
    return (
      <EmptyState
        title="No providers"
        message="Add a provider first to see channels."
        actionLabel="Add Provider"
        onAction={() => navigation.navigate('ProviderAdd')}
      />
    );
  }

  if (isLoading) {
    return <LoadingView />;
  }

  if (channels.length === 0) {
    return (
      <EmptyState
        title="No channels"
        message="Sync your provider to load channels."
      />
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background, paddingTop: top }]}>
      {providers.length > 1 ? (
        <FlatList
          horizontal
          data={providers}
          keyExtractor={p => p.id}
          contentContainerStyle={styles.providerTabs}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={[
                styles.providerTab,
                {
                  backgroundColor:
                    selectedProviderId === item.id ? theme.colors.primary : theme.colors.surface,
                  borderColor: theme.colors.border,
                },
              ]}
              onPress={() => setActiveProvider(item.id)}
            >
              <Text
                style={[
                  styles.providerTabText,
                  selectedProviderId === item.id ? styles.providerTabTextActive : tabTextUnselected,
                ]}
              >
                {item.name}
              </Text>
            </TouchableOpacity>
          )}
        />
      ) : null}

      <SectionList
        sections={sections}
        keyExtractor={item => item.id}
        stickySectionHeadersEnabled
        refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={refetch} />}
        renderSectionHeader={({ section }) => (
          <View style={[styles.sectionHeader, { backgroundColor: theme.colors.surfaceVariant }]}>
            <Text style={[styles.sectionTitle, { color: theme.colors.textSecondary }]}>
              {section.title} ({section.data.length})
            </Text>
          </View>
        )}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.row, { borderBottomColor: theme.colors.border }]}
            onPress={() =>
              navigation.navigate('Player', {
                channelId: item.id,
                streamUrl: item.streamUrl,
                channelName: item.name,
              })
            }
            onLongPress={() => setLongPressedChannel(item)}
            delayLongPress={400}
          >
            {item.logoUrl ? (
              <Image source={{ uri: item.logoUrl }} style={styles.logo} resizeMode="contain" />
            ) : (
              <View style={[styles.logoPlaceholder, { backgroundColor: theme.colors.surface }]}>
                <Text style={[styles.logoInitial, { color: theme.colors.textSecondary }]}>
                  {item.name.charAt(0).toUpperCase()}
                </Text>
              </View>
            )}
            <View style={styles.info}>
              <Text style={[styles.channelName, { color: theme.colors.text }]} numberOfLines={1}>
                {item.name}
              </Text>
              {item.tvgId ? (
                <Text style={[styles.tvgId, { color: theme.colors.textSecondary }]} numberOfLines={1}>
                  {item.tvgId}
                </Text>
              ) : null}
            </View>
            <FavouriteButton channelId={item.id} size={20} />
          </TouchableOpacity>
        )}
      />

      {/* Add-to-playlist modal (triggered by long-press) */}
      {longPressedChannel && (
        <Modal transparent animationType="fade" onRequestClose={() => setLongPressedChannel(null)}>
          <Pressable style={styles.modalBackdrop} onPress={() => setLongPressedChannel(null)}>
            <View
              style={[styles.playlistPicker, { backgroundColor: theme.colors.surface, borderColor: theme.colors.border }]}
              onStartShouldSetResponder={() => true}
            >
              <Text style={[styles.pickerTitle, { color: theme.colors.text }]} numberOfLines={1}>
                Add "{longPressedChannel.name}" to…
              </Text>
              {userPlaylists.length === 0 ? (
                <Text style={[styles.pickerEmpty, { color: theme.colors.textSecondary }]}>
                  No playlists yet. Create one in the Playlists tab.
                </Text>
              ) : (
                userPlaylists.map((pl: Playlist) => (
                  <TouchableOpacity
                    key={pl.id}
                    style={[styles.pickerRow, { borderTopColor: theme.colors.border }]}
                    onPress={() => handleAddToPlaylist(pl)}
                  >
                    <Text style={[styles.pickerRowText, { color: theme.colors.text }]}>{pl.name}</Text>
                    <Text style={[styles.pickerCount, { color: theme.colors.textSecondary }]}>
                      {pl.channelIds.length} channels
                    </Text>
                  </TouchableOpacity>
                ))
              )}
              <TouchableOpacity
                style={[styles.pickerCancel, { borderTopColor: theme.colors.border }]}
                onPress={() => setLongPressedChannel(null)}
              >
                <Text style={[styles.pickerCancelText, { color: theme.colors.textSecondary }]}>Cancel</Text>
              </TouchableOpacity>
            </View>
          </Pressable>
        </Modal>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  providerTabs: { paddingHorizontal: 12, paddingVertical: 8, gap: 8 },
  providerTab: {
    paddingHorizontal: 14,
    paddingVertical: 7,
    borderRadius: 20,
    borderWidth: 1,
  },
  providerTabText: { fontSize: 13, fontWeight: '500' },
  providerTabTextActive: { color: '#fff' },
  sectionHeader: {
    paddingHorizontal: 16,
    paddingVertical: 6,
  },
  sectionTitle: { fontSize: 12, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 0.5 },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
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
  channelName: { fontSize: 15, fontWeight: '500' },
  tvgId: { fontSize: 12, marginTop: 1 },

  // Add-to-playlist modal
  modalBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.45)',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  playlistPicker: {
    borderRadius: 14,
    borderWidth: StyleSheet.hairlineWidth,
    overflow: 'hidden',
  },
  pickerTitle: {
    fontSize: 14,
    fontWeight: '600',
    paddingHorizontal: 16,
    paddingVertical: 14,
  },
  pickerEmpty: { fontSize: 13, paddingHorizontal: 16, paddingBottom: 14 },
  pickerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 14,
    borderTopWidth: StyleSheet.hairlineWidth,
  },
  pickerRowText: { fontSize: 15 },
  pickerCount: { fontSize: 12 },
  pickerCancel: { borderTopWidth: StyleSheet.hairlineWidth, paddingVertical: 14, alignItems: 'center' },
  pickerCancelText: { fontSize: 15 },
});
