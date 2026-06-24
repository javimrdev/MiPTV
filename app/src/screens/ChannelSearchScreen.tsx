import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { RootStackScreenProps } from '../navigation/types';

export function ChannelSearchScreen(_props: RootStackScreenProps<'ChannelSearch'>) {
  return (
    <View style={styles.container}>
      <Text style={styles.placeholder}>Channel Search — coming soon</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  placeholder: { fontSize: 16, color: '#999' },
});
