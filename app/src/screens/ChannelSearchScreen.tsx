import React, { useState, useCallback } from 'react';
import {
  View,
  Text,
  TextInput,
  FlatList,
  TouchableOpacity,
  Image,
  StyleSheet,
} from 'react-native';
import { useChannelSearch } from '../hooks/useChannels';
import { LoadingView } from '../components/LoadingView';
import { ThemedText } from '../components/ThemedText';
import { useTheme } from '../theme/useTheme';
import type { RootStackScreenProps } from '../navigation/types';
import type { Channel } from '../specs/NativeMiPTVCore';

export function ChannelSearchScreen({ navigation }: RootStackScreenProps<'ChannelSearch'>) {
  const theme = useTheme();
  const [query, setQuery] = useState('');
  const { data: channels = [], isFetching } = useChannelSearch(query);

  const handleClear = useCallback(() => setQuery(''), []);

  const renderItem = useCallback(
    ({ item }: { item: Channel }) => (
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
      </TouchableOpacity>
    ),
    [navigation, theme],
  );

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <View style={[styles.searchBar, { backgroundColor: theme.colors.surface, borderColor: theme.colors.border }]}>
        <Text style={[styles.searchIcon, { color: theme.colors.textSecondary }]}>🔍</Text>
        <TextInput
          style={[styles.input, { color: theme.colors.text }]}
          placeholder="Search channels…"
          placeholderTextColor={theme.colors.textDisabled}
          value={query}
          onChangeText={setQuery}
          autoFocus
          returnKeyType="search"
          autoCapitalize="none"
        />
        {query.length > 0 ? (
          <TouchableOpacity onPress={handleClear} style={styles.clearBtn}>
            <Text style={[styles.clearText, { color: theme.colors.textSecondary }]}>✕</Text>
          </TouchableOpacity>
        ) : null}
      </View>

      {query.length < 2 ? (
        <View style={styles.hint}>
          <ThemedText variant="body" secondary>Type at least 2 characters to search</ThemedText>
        </View>
      ) : isFetching ? (
        <LoadingView />
      ) : channels.length === 0 ? (
        <View style={styles.hint}>
          <ThemedText variant="body" secondary>No channels found for "{query}"</ThemedText>
        </View>
      ) : (
        <FlatList
          data={channels}
          keyExtractor={item => item.id}
          renderItem={renderItem}
          keyboardShouldPersistTaps="handled"
          keyboardDismissMode="on-drag"
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    margin: 12,
    borderRadius: 10,
    borderWidth: 1,
    paddingHorizontal: 10,
    height: 44,
  },
  searchIcon: { fontSize: 16, marginRight: 6 },
  input: { flex: 1, fontSize: 15 },
  clearBtn: { padding: 4 },
  clearText: { fontSize: 16 },
  hint: { flex: 1, alignItems: 'center', justifyContent: 'center' },
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
