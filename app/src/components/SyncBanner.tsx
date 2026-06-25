import React from 'react';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import { ThemedText } from './ThemedText';
import { useTheme } from '../theme/useTheme';
import { useSyncStore } from '../store/syncStore';

export function SyncBanner() {
  const theme = useTheme();
  const syncStates = useSyncStore(s => s.providers);

  const syncing = Object.values(syncStates).filter(s => s.status === 'syncing');
  const errors = Object.values(syncStates).filter(s => s.status === 'error');

  if (syncing.length === 0 && errors.length === 0) {
    return null;
  }

  const bgColor = errors.length > 0 ? theme.colors.error : theme.colors.primary;

  return (
    <View style={[styles.banner, { backgroundColor: bgColor }]}>
      {syncing.length > 0 ? (
        <>
          <ActivityIndicator size="small" color="#fff" style={styles.icon} />
          <ThemedText variant="caption" style={styles.text}>
            Syncing {syncing.length} provider{syncing.length > 1 ? 's' : ''}…
          </ThemedText>
        </>
      ) : (
        <ThemedText variant="caption" style={styles.text} numberOfLines={2}>
          Sync failed for {errors.length} provider{errors.length > 1 ? 's' : ''}
          {errors[0]?.error ? `: ${errors[0].error}` : ''}
        </ThemedText>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  banner: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  icon: { marginRight: 8 },
  text: { color: '#fff', flex: 1 },
});
