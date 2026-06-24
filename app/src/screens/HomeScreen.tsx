import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { TabScreenProps } from '../navigation/types';

export function HomeScreen(_props: TabScreenProps<'HomeTab'>) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>MiPTV</Text>
      <Text style={styles.subtitle}>Add a provider to get started</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  title: { fontSize: 28, fontWeight: 'bold', marginBottom: 8 },
  subtitle: { fontSize: 16, color: '#666' },
});
