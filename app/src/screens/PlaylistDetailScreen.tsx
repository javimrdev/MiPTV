import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { RootStackScreenProps } from '../navigation/types';

export function PlaylistDetailScreen({ route }: RootStackScreenProps<'PlaylistDetail'>) {
  const { name } = route.params;
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{name}</Text>
      <Text style={styles.placeholder}>Playlist Detail — coming soon</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  title: { fontSize: 20, fontWeight: 'bold', marginBottom: 8 },
  placeholder: { fontSize: 16, color: '#999' },
});
