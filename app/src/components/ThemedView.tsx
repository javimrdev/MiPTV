import React from 'react';
import { View, type ViewProps } from 'react-native';
import { useTheme } from '../theme/useTheme';

type ThemedViewProps = ViewProps & {
  surface?: boolean;
};

export function ThemedView({ surface, style, ...rest }: ThemedViewProps) {
  const theme = useTheme();
  const bg = surface ? theme.colors.surface : theme.colors.background;
  return <View style={[{ backgroundColor: bg }, style]} {...rest} />;
}
