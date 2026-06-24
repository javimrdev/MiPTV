import React from 'react';
import { View, StyleSheet } from 'react-native';
import { useTheme } from '../theme/useTheme';

export function Separator() {
  const theme = useTheme();
  return <View style={[styles.line, { backgroundColor: theme.colors.border }]} />;
}

const styles = StyleSheet.create({
  line: { height: StyleSheet.hairlineWidth, marginVertical: 4 },
});
