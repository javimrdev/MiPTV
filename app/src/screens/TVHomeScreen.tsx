import React, { useMemo } from 'react';
import {
  FlatList,
  Image,
  ScrollView,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { TVFocusGuideView } from 'react-native';
import { usePlayerStore } from '../store/playerStore';
import { useFavouritesStore } from '../store/favouritesStore';
import { useProviders } from '../hooks/useProviders';
import { useProviderStore } from '../store/providerStore';
import { useChannels } from '../hooks/useChannels';
import { useCurrentEpg } from '../hooks/useEpg';
import { useRecentlyWatched } from '../hooks/useWatchHistory';
import { usePlaylists } from '../hooks/usePlaylists';
import { TVChannelCard } from '../components/TVChannelCard';
import { PrimaryButton } from '../components/PrimaryButton';
import type { Channel } from '../specs/NativeMiPTVCore';
import type { TabScreenProps } from '../navigation/types';

type Props = Pick<TabScreenProps<'HomeTab'>, 'navigation'>;

type ChannelRowProps = {
  title: string;
  channels: Channel[];
  onChannelPress: (ch: Channel) => void;
  firstFocused?: boolean;
};

function ChannelRow({ title, channels, onChannelPress, firstFocused }: ChannelRowProps) {
  if (channels.length === 0) {
    return null;
  }
  return (
    <View style={styles.row}>
      <Text style={styles.rowTitle}>{title}</Text>
      <FlatList
        data={channels}
        horizontal
        showsHorizontalScrollIndicator={false}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.rowContent}
        renderItem={({ item, index }) => (
          <TVChannelCard
            channel={item}
            onPress={() => onChannelPress(item)}
            hasTVPreferredFocus={firstFocused && index === 0}
          />
        )}
      />
    </View>
  );
}

export function TVHomeScreen({ navigation }: Props) {
  const { currentChannel } = usePlayerStore();
  const { favouriteIds } = useFavouritesStore();
  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const providerId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: allChannels = [] } = useChannels(providerId);
  const { data: recentChannels = [] } = useRecentlyWatched(15);
  const { data: playlists = [] } = usePlaylists();

  const heroChannel = currentChannel ?? recentChannels[0] ?? allChannels[0] ?? null;
  const { data: heroEpg } = useCurrentEpg(heroChannel?.id ?? '');

  const favouriteChannels = useMemo<Channel[]>(() => {
    const favPlaylist = playlists.find((p) => p.isFavorites);
    if (favPlaylist) {
      return favPlaylist.channelIds
        .map((id) => allChannels.find((ch) => ch.id === id))
        .filter((ch): ch is Channel => ch !== undefined);
    }
    return allChannels.filter((ch) => favouriteIds.has(ch.id));
  }, [playlists, allChannels, favouriteIds]);

  const browseChannels = useMemo<Channel[]>(() => allChannels.slice(0, 20), [allChannels]);

  const openPlayer = (ch: Channel) => {
    navigation.navigate('Player', {
      channelId: ch.id,
      streamUrl: ch.streamUrl,
      channelName: ch.name,
    });
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* ── Hero ─────────────────────────────────────────────────────────────── */}
      {heroChannel && (
        <TVFocusGuideView autoFocus style={styles.hero}>
          <View style={styles.heroBg}>
            {heroChannel.logoUrl ? (
              <Image
                source={{ uri: heroChannel.logoUrl }}
                style={styles.heroLogo}
                resizeMode="contain"
              />
            ) : (
              <View style={styles.heroLogoPlaceholder} />
            )}
          </View>
          <View style={styles.heroInfo}>
            <Text style={styles.heroChannel}>{heroChannel.name}</Text>
            {heroEpg && (
              <>
                <Text style={styles.heroNow}>Now Playing</Text>
                <Text style={styles.heroTitle} numberOfLines={2}>{heroEpg.title}</Text>
                {heroEpg.description && (
                  <Text style={styles.heroDesc} numberOfLines={3}>{heroEpg.description}</Text>
                )}
              </>
            )}
            <PrimaryButton
              label="► Watch Now"
              onPress={() => openPlayer(heroChannel)}
              style={styles.watchBtn}
              hasTVPreferredFocus
            />
          </View>
        </TVFocusGuideView>
      )}

      {/* ── Rows ─────────────────────────────────────────────────────────────── */}
      <TVFocusGuideView autoFocus style={styles.rows}>
        <ChannelRow
          title="Favorites"
          channels={favouriteChannels}
          onChannelPress={openPlayer}
          firstFocused={!heroChannel}
        />
        <ChannelRow
          title="Continue Watching"
          channels={recentChannels}
          onChannelPress={openPlayer}
        />
        <ChannelRow
          title="All Channels"
          channels={browseChannels}
          onChannelPress={openPlayer}
          firstFocused={!heroChannel && favouriteChannels.length === 0 && recentChannels.length === 0}
        />
        {allChannels.length === 0 && (
          <View style={styles.emptyState}>
            <Text style={styles.emptyText}>No channels yet. Add a provider to get started.</Text>
            <PrimaryButton
              label="Add Provider"
              onPress={() => navigation.navigate('ProviderAdd')}
              style={styles.emptyBtn}
              hasTVPreferredFocus={!heroChannel}
            />
          </View>
        )}
      </TVFocusGuideView>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a18' },
  content: { paddingBottom: 40 },

  // Hero
  hero: { flexDirection: 'row', minHeight: 320, padding: 40, alignItems: 'center' },
  heroBg: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  heroLogo: { width: 280, height: 160 },
  heroLogoPlaceholder: { width: 280, height: 160, backgroundColor: '#1a2a4a', borderRadius: 12 },
  heroInfo: { flex: 1, paddingLeft: 48 },
  heroChannel: { color: '#fff', fontSize: 36, fontWeight: '700', marginBottom: 8 },
  heroNow: { color: '#007AFF', fontSize: 14, fontWeight: '600', marginBottom: 4 },
  heroTitle: { color: '#e0e0e0', fontSize: 22, fontWeight: '500', marginBottom: 8 },
  heroDesc: { color: '#9ca3af', fontSize: 15, lineHeight: 22, marginBottom: 24 },
  watchBtn: { alignSelf: 'flex-start', paddingHorizontal: 32, height: 56 },

  // Rows
  rows: { paddingTop: 16 },
  row: { marginBottom: 32 },
  rowTitle: { color: '#fff', fontSize: 22, fontWeight: '600', marginLeft: 16, marginBottom: 12 },
  rowContent: { paddingHorizontal: 8 },

  // Empty
  emptyState: { alignItems: 'center', padding: 48 },
  emptyText: { color: '#9ca3af', fontSize: 18, textAlign: 'center', marginBottom: 24 },
  emptyBtn: { paddingHorizontal: 32 },
});
