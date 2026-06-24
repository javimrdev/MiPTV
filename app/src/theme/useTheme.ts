import { useColorScheme } from 'react-native';
import { colors, spacing, radius, fontSize, fontWeight } from './tokens';

const lightTheme = {
  colors: {
    background: colors.white,
    surface: colors.grey50,
    surfaceVariant: colors.grey100,
    border: colors.grey200,
    text: colors.grey900,
    textSecondary: colors.grey500,
    textDisabled: colors.grey300,
    primary: colors.primary,
    primaryForeground: colors.white,
    error: colors.error,
    success: colors.success,
    warning: colors.warning,
    tabBar: colors.white,
    tabBarBorder: colors.grey200,
  },
  spacing,
  radius,
  fontSize,
  fontWeight,
  dark: false,
};

const darkTheme = {
  colors: {
    background: colors.grey900,
    surface: colors.grey800,
    surfaceVariant: colors.grey700,
    border: colors.grey700,
    text: colors.white,
    textSecondary: colors.grey400,
    textDisabled: colors.grey600,
    primary: colors.primary,
    primaryForeground: colors.white,
    error: colors.error,
    success: colors.success,
    warning: colors.warning,
    tabBar: colors.grey900,
    tabBarBorder: colors.grey700,
  },
  spacing,
  radius,
  fontSize,
  fontWeight,
  dark: true,
};

export type Theme = typeof lightTheme;

export function useTheme(): Theme {
  const scheme = useColorScheme();
  return scheme === 'dark' ? darkTheme : lightTheme;
}
