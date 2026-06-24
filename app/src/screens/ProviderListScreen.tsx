import React, { useCallback } from 'react';
import {
  FlatList,
  View,
  Text,
  TouchableOpacity,
  Alert,
  StyleSheet,
  RefreshControl,
} from 'react-native';
import { useProviders, useDeleteProvider, useSyncProvider } from '../hooks/useProviders';
import { LoadingView } from '../components/LoadingView';
import { EmptyState } from '../components/EmptyState';
import { useTheme } from '../theme/useTheme';
import type { RootStackScreenProps } from '../navigation/types';
import type { Provider } from '../specs/NativeMiPTVCore';

export function ProviderListScreen({ navigation }: RootStackScreenProps<'ProviderList'>) {
  const theme = useTheme();
  const { data: providers = [], isLoading, refetch, isRefetching } = useProviders();
  const deleteProvider = useDeleteProvider();
  const syncProvider = useSyncProvider();

  const handleDelete = useCallback(
    (provider: Provider) => {
      Alert.alert('Delete Provider', `Remove "${provider.name}"?`, [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => deleteProvider.mutate(provider.id),
        },
      ]);
    },
    [deleteProvider],
  );

  const handleSync = useCallback(
    (provider: Provider) => {
      syncProvider.mutate(provider.id);
    },
    [syncProvider],
  );

  if (isLoading) {
    return <LoadingView />;
  }

  if (providers.length === 0) {
    return (
      <EmptyState
        title="No providers yet"
        message="Add an M3U URL or Xtream Codes provider to get started."
        actionLabel="Add Provider"
        onAction={() => navigation.navigate('ProviderAdd')}
      />
    );
  }

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <FlatList
        data={providers}
        keyExtractor={item => item.id}
        refreshControl={<RefreshControl refreshing={isRefetching} onRefresh={refetch} />}
        renderItem={({ item }) => (
          <View style={[styles.row, { borderBottomColor: theme.colors.border }]}>
            <View style={styles.info}>
              <Text style={[styles.name, { color: theme.colors.text }]}>{item.name}</Text>
              <Text style={[styles.type, { color: theme.colors.textSecondary }]}>
                {item.providerType.replace('_', ' ')} · {item.url}
              </Text>
            </View>
            <View style={styles.actions}>
              <TouchableOpacity
                style={[styles.btn, { backgroundColor: theme.colors.primary }]}
                onPress={() => handleSync(item)}
              >
                <Text style={styles.btnText}>Sync</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.btn, { backgroundColor: theme.colors.error }]}
                onPress={() => handleDelete(item)}
              >
                <Text style={styles.btnText}>Delete</Text>
              </TouchableOpacity>
            </View>
          </View>
        )}
        ListFooterComponent={
          <TouchableOpacity
            style={[styles.addBtn, { borderColor: theme.colors.primary }]}
            onPress={() => navigation.navigate('ProviderAdd')}
          >
            <Text style={[styles.addBtnText, { color: theme.colors.primary }]}>+ Add Provider</Text>
          </TouchableOpacity>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  info: { flex: 1 },
  name: { fontSize: 15, fontWeight: '600', marginBottom: 2 },
  type: { fontSize: 12 },
  actions: { flexDirection: 'row', gap: 8 },
  btn: { paddingHorizontal: 12, paddingVertical: 6, borderRadius: 6 },
  btnText: { color: '#fff', fontSize: 13, fontWeight: '600' },
  addBtn: {
    margin: 16,
    padding: 14,
    borderWidth: 1,
    borderRadius: 8,
    alignItems: 'center',
    borderStyle: 'dashed',
  },
  addBtnText: { fontSize: 15, fontWeight: '600' },
});
