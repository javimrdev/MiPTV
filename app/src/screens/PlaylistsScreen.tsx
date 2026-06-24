import React, { useMemo } from 'react';
import {
  View,
  Text,
  SectionList,
  TouchableOpacity,
  Image,
  StyleSheet,
} from 'react-native';
import type { Playlist } from '../specs/NativeMiPTVCore';
import { useFavouritesStore } from '../store/favouritesStore';
import { usePlaylists } from '../hooks/usePlaylists';
import { useProviderStore } from '../store/providerStore';
import { useProviders } from '../hooks/useProviders';
import { useChannels } from '../hooks/useChannels';
import { FavouriteButton } from '../components/FavouriteButton';
import { EmptyState } from '../components/EmptyState';
import { ThemedText } from '../components/ThemedText';
import { useTheme } from '../theme/useTheme';
import type { TabScreenProps } from '../navigation/types';
import type { Channel } from '../specs/NativeMiPTVCore';

export function PlaylistsScreen({ navigation }: TabScreenProps<'PlaylistsTab'>) {
  const theme = useTheme();
  const favouriteIds = useFavouritesStore(s => s.favouriteIds);
  const { data: playlists = [] } = usePlaylists();
  const { data: providers = [] } = useProviders();
  const { activeProviderId } = useProviderStore();
  const selectedProviderId = activeProviderId ?? providers[0]?.id ?? '';
  const { data: allChannels = [] } = useChannels(selectedProviderId);

  const favouriteChannels = useMemo(
    () => allChannels.filter((ch: Channel) => favouriteIds.has(ch.id)),
    [allChannels, favouriteIds],
  );

  type Section = { title: string; data: Channel[] };
  const sections = useMemo<Section[]>(() => {
    const result: Section[] = [];
    if (favouriteChannels.length > 0) {
      result.push({ title: 'Favourites ★', data: favouriteChannels });
    }
    playlists.forEach((pl: Playlist) => {
      const chans = pl.channelIds
        .map((id: string) => allChannels.find((ch: Channel) => ch.id === id))
        .filter((ch): ch is Channel => ch !== undefined);
      if (chans.length > 0) {
        result.push({ title: pl.name, data: chans });
      }
    });
    return result;
  }, [favouriteChannels, playlists, allChannels]);

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

  if (sections.length === 0) {
    return (
      <EmptyState
        title="No playlists yet"
        message="Tap ☆ on any channel to add it to Favourites."
      />
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <SectionList
        sections={sections}
        keyExtractor={item => item.id}
        stickySectionHeadersEnabled
        renderSectionHeader={({ section }) => (
          <View style={[styles.sectionHeader, { backgroundColor: theme.colors.surfaceVariant }]}>
            <ThemedText variant="label" secondary>{section.title}</ThemedText>
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
              <Text style={[styles.name, { color: theme.colors.text }]} numberOfLines={1}>
                {item.name}
              </Text>
              <Text style={[styles.group, { color: theme.colors.textSecondary }]} numberOfLines={1}>
                {item.group}
              </Text>
            </View>
            <FavouriteButton channelId={item.id} size={18} />
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  sectionHeader: { paddingHorizontal: 16, paddingVertical: 8 },
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
  name: { fontSize: 15, fontWeight: '500' },
  group: { fontSize: 12, marginTop: 1 },
});
