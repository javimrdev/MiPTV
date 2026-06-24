import React from 'react';
import { Text, StyleSheet, type TextProps } from 'react-native';
import { useTheme } from '../theme/useTheme';

type Variant = 'title' | 'subtitle' | 'body' | 'caption' | 'label';

type ThemedTextProps = TextProps & {
  variant?: Variant;
  secondary?: boolean;
};

export function ThemedText({ variant = 'body', secondary, style, ...rest }: ThemedTextProps) {
  const theme = useTheme();
  const color = secondary ? theme.colors.textSecondary : theme.colors.text;

  return <Text style={[styles[variant], { color }, style]} {...rest} />;
}

const styles = StyleSheet.create({
  title: { fontSize: 24, fontWeight: '700', lineHeight: 32 },
  subtitle: { fontSize: 17, fontWeight: '600', lineHeight: 24 },
  body: { fontSize: 15, fontWeight: '400', lineHeight: 22 },
  caption: { fontSize: 12, fontWeight: '400', lineHeight: 18 },
  label: { fontSize: 13, fontWeight: '500', lineHeight: 20 },
});
