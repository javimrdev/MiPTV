import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { TabScreenProps } from '../navigation/types';

export function ChannelsScreen(_props: TabScreenProps<'ChannelsTab'>) {
  return (
    <View style={styles.container}>
      <Text style={styles.placeholder}>Channels — coming soon</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  placeholder: { fontSize: 16, color: '#999' },
});
