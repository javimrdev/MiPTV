import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { TabScreenProps } from '../navigation/types';

export function SettingsScreen(_props: TabScreenProps<'SettingsTab'>) {
  return (
    <View style={styles.container}>
      <Text style={styles.placeholder}>Settings — coming soon</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  placeholder: { fontSize: 16, color: '#999' },
});
