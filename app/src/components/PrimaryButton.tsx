import React, { useState } from 'react';
import {
  ActivityIndicator,
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  type ViewStyle,
} from 'react-native';
import { useTheme } from '../theme/useTheme';

type PrimaryButtonProps = {
  label: string;
  onPress: () => void;
  loading?: boolean;
  disabled?: boolean;
  style?: ViewStyle;
  hasTVPreferredFocus?: boolean;
};

export function PrimaryButton({
  label,
  onPress,
  loading,
  disabled,
  style,
  hasTVPreferredFocus,
}: PrimaryButtonProps) {
  const [tvFocused, setTvFocused] = useState(false);
  const theme = useTheme();
  const isDisabled = disabled || loading;
  const showRing = tvFocused && Platform.isTV;

  return (
    <TouchableOpacity
      style={[
        styles.button,
        { backgroundColor: theme.colors.primary, borderRadius: theme.radius.md },
        isDisabled && styles.disabled,
        showRing && styles.ring,
        style,
      ]}
      onPress={onPress}
      disabled={isDisabled}
      activeOpacity={0.8}
      hasTVPreferredFocus={hasTVPreferredFocus}
      onFocus={() => setTvFocused(true)}
      onBlur={() => setTvFocused(false)}
    >
      {loading ? (
        <ActivityIndicator color={theme.colors.primaryForeground} size="small" />
      ) : (
        <Text style={[styles.label, { color: theme.colors.primaryForeground }]}>{label}</Text>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  button: {
    height: 48,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  label: { fontSize: 15, fontWeight: '600' },
  disabled: { opacity: 0.5 },
  ring: { borderWidth: 3, borderColor: '#007AFF' },
});
