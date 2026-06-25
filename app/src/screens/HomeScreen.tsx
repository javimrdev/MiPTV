import React from 'react';
import {
  FlatList,
  Image,
  Platform,
  ScrollView,
  StyleSheet,
  View,
} from 'react-native';
import { useProviders } from '../hooks/useProviders';
import { useAutoSync } from '../hooks/useAutoSync';
import { useRecentlyWatched, useMostWatched } from '../hooks/useWatchHistory';
import { ThemedText } from '../components/ThemedText';
import { PrimaryButton } from '../components/PrimaryButton';
import { TVFocusable } from '../components/TVFocusable';
import { LoadingView } from '../components/LoadingView';
import { SyncBanner } from '../components/SyncBanner';
import { useTheme } from '../theme/useTheme';
import type { Channel } from '../specs/NativeMiPTVCore';
import type { TabScreenProps } from '../navigation/types';

const CARD_W = 120;
const CARD_H = 80;

type ChannelCardProps = {
  channel: Channel;
  onPress: () => void;
};

function ChannelCard({ channel, onPress }: ChannelCardProps) {
  const theme = useTheme();
  return (
    <TVFocusable style={[styles.card, { backgroundColor: theme.colors.surface }]} onPress={onPress}>
      {channel.logoUrl ? (
        <Image source={{ uri: channel.logoUrl }} style={styles.logo} resizeMode="contain" />
      ) : (
        <View style={[styles.logo, styles.logoPlaceholder]}>
          <ThemedText variant="label" numberOfLines={2} style={styles.placeholderText}>
            {channel.name}
          </ThemedText>
        </View>
      )}
      <ThemedText variant="label" numberOfLines={1} style={styles.cardName}>
        {channel.name}
      </ThemedText>
    </TVFocusable>
  );
}

type CarouselProps = {
  title: string;
  channels: Channel[];
  onChannelPress: (ch: Channel) => void;
};

function Carousel({ title, channels, onChannelPress }: CarouselProps) {
  const theme = useTheme();
  if (channels.length === 0) {
    return null;
  }
  return (
    <View style={styles.section}>
      <ThemedText variant="subtitle" style={[styles.sectionTitle, { color: theme.colors.text }]}>
        {title}
      </ThemedText>
      <FlatList
        data={channels}
        horizontal
        showsHorizontalScrollIndicator={false}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.carouselContent}
        renderItem={({ item }) => (
          <ChannelCard channel={item} onPress={() => onChannelPress(item)} />
        )}
      />
    </View>
  );
}

export function HomeScreen({ navigation }: TabScreenProps<'HomeTab'>) {
  const theme = useTheme();
  const { data: providers = [], isLoading } = useProviders();
  const { data: recentChannels = [] } = useRecentlyWatched(20);
  const { data: mostChannels = [] } = useMostWatched(20);

  useAutoSync(providers);

  const openPlayer = (ch: Channel) => {
    navigation.navigate('Player', {
      channelId: ch.id,
      streamUrl: ch.streamUrl,
      channelName: ch.name,
    });
  };

  if (isLoading) {
    return <LoadingView />;
  }

  const hasCarousels = recentChannels.length > 0 || mostChannels.length > 0;

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <SyncBanner />
      {hasCarousels ? (
        <ScrollView style={styles.scroll} contentContainerStyle={styles.scrollContent}>
          <ThemedText variant="title" style={styles.pageTitle}>MiPTV</ThemedText>
          <Carousel title="Recently Watched" channels={recentChannels} onChannelPress={openPlayer} />
          <Carousel title="Most Watched" channels={mostChannels} onChannelPress={openPlayer} />
          {providers.length === 0 && (
            <View style={styles.body}>
              <ThemedText variant="body" secondary style={styles.msg}>
                Add a provider to start watching
              </ThemedText>
              <PrimaryButton
                label="Add Provider"
                onPress={() => navigation.navigate('ProviderAdd')}
                hasTVPreferredFocus={Platform.isTV}
              />
            </View>
          )}
        </ScrollView>
      ) : (
        <View style={styles.body}>
          <ThemedText variant="title" style={styles.title}>MiPTV</ThemedText>
          {providers.length === 0 ? (
            <>
              <ThemedText variant="body" secondary style={styles.msg}>
                Add a provider to start watching
              </ThemedText>
              <PrimaryButton
                label="Add Provider"
                onPress={() => navigation.navigate('ProviderAdd')}
                hasTVPreferredFocus={Platform.isTV}
              />
            </>
          ) : (
            <>
              <ThemedText variant="body" secondary style={styles.msg}>
                {providers.length} provider{providers.length > 1 ? 's' : ''} configured
              </ThemedText>
              <PrimaryButton
                label="Manage Providers"
                onPress={() => navigation.navigate('ProviderList')}
                hasTVPreferredFocus={Platform.isTV}
              />
            </>
          )}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  scroll: { flex: 1 },
  scrollContent: { paddingBottom: 32 },
  pageTitle: { marginTop: 16, marginBottom: 8, marginHorizontal: 16 },
  section: { marginTop: 24 },
  sectionTitle: { marginHorizontal: 16, marginBottom: 8, fontWeight: '600' },
  carouselContent: { paddingHorizontal: 12 },
  card: {
    width: CARD_W,
    marginHorizontal: 4,
    borderRadius: 8,
    overflow: 'hidden',
  },
  logo: {
    width: CARD_W,
    height: CARD_H,
  },
  logoPlaceholder: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#1a1a2e',
  },
  placeholderText: { color: '#fff', textAlign: 'center', paddingHorizontal: 4 },
  cardName: { paddingHorizontal: 6, paddingVertical: 4 },
  body: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  title: { marginBottom: 8 },
  msg: { marginBottom: 24, textAlign: 'center' },
});
