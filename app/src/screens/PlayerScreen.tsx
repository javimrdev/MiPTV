import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import type { RootStackScreenProps } from '../navigation/types';

export function PlayerScreen({ route, navigation }: RootStackScreenProps<'Player'>) {
  const { channelName } = route.params;

  return (
    <View style={styles.container}>
      <Text style={styles.channel}>{channelName}</Text>
      <Text style={styles.placeholder}>Player — coming soon</Text>
      <TouchableOpacity style={styles.close} onPress={() => navigation.goBack()}>
        <Text style={styles.closeText}>✕</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#000', alignItems: 'center', justifyContent: 'center' },
  channel: { fontSize: 18, color: '#fff', marginBottom: 12 },
  placeholder: { fontSize: 14, color: '#666' },
  close: { position: 'absolute', top: 48, right: 20 },
  closeText: { fontSize: 24, color: '#fff' },
});
