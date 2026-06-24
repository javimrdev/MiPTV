import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import type { RootStackScreenProps } from '../navigation/types';

export function ProviderListScreen(_props: RootStackScreenProps<'ProviderList'>) {
  return (
    <View style={styles.container}>
      <Text style={styles.placeholder}>Provider List — coming soon</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center' },
  placeholder: { fontSize: 16, color: '#999' },
});
