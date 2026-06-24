import React from 'react';
import { View, StyleSheet } from 'react-native';
import { ThemedText } from './ThemedText';
import { PrimaryButton } from './PrimaryButton';

type EmptyStateProps = {
  title: string;
  message?: string;
  actionLabel?: string;
  onAction?: () => void;
};

export function EmptyState({ title, message, actionLabel, onAction }: EmptyStateProps) {
  return (
    <View style={styles.container}>
      <ThemedText variant="subtitle" style={styles.title}>{title}</ThemedText>
      {message ? (
        <ThemedText variant="body" secondary style={styles.message}>{message}</ThemedText>
      ) : null}
      {actionLabel && onAction ? (
        <PrimaryButton label={actionLabel} onPress={onAction} style={styles.action} />
      ) : null}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 32 },
  title: { marginBottom: 8, textAlign: 'center' },
  message: { marginBottom: 24, textAlign: 'center' },
  action: { minWidth: 160 },
});
