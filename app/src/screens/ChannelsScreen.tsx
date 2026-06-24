import React, { useMemo, useState } from 'react';
import {
  View,
  Text,
  FlatList,
  SectionList,
  TouchableOpacity,
  Image,
  StyleSheet,
  RefreshControl,
} from 'react-native';
import { useChannels } from '../hooks/useChannels';
import { useProviderStore } from '../store/providerStore';
import { useProviders } from '../hooks/useProviders';
import { LoadingView } from '../components/LoadingView';
import { EmptyState } from '../components/EmptyState';
import { useTheme } from '../theme/useTheme';
import type { TabScreenProps } from '../navigation/types';
import type { Channel } from '../specs/NativeMiPTVCore';

type Section = { title: string; data: Channel[] };

export function ChannelsScreen({ navigation }: TabScreenProps<'ChannelsTab'>) {
  const theme = useTheme();
  const { data: providers = [] } = useProviders();
  const { activeProviderId, setActiveProvider } = useProviderStore();

  const firstProvider = providers[0];
  const selectedProviderId = activeProviderId ?? firstProvider?.id ?? '';

  const { data: channels = [], isLoading, refetch, isRefetching } = useChannels(selectedProviderId);

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
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
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
                  { color: selectedProviderId === item.id ? '#fff' : theme.colors.text },
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
          </TouchableOpacity>
        )}
      />
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
});
