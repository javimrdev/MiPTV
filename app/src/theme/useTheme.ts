import { useColorScheme } from 'react-native';
import { colors, spacing, radius, fontSize, fontWeight } from './tokens';
import { useSettingsStore } from '../store/settingsStore';

export type Theme = {
  colors: {
    background: string;
    surface: string;
    surfaceVariant: string;
    border: string;
    text: string;
    textSecondary: string;
    textDisabled: string;
    primary: string;
    primaryForeground: string;
    error: string;
    success: string;
    warning: string;
    tabBar: string;
    tabBarBorder: string;
  };
  spacing: typeof spacing;
  radius: typeof radius;
  fontSize: typeof fontSize;
  fontWeight: typeof fontWeight;
  dark: boolean;
};

const lightTheme: Theme = {
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

const darkTheme: Theme = {
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

export function useTheme(): Theme {
  const systemScheme = useColorScheme();
  const { theme } = useSettingsStore();
  const effective = theme === 'system' ? systemScheme : theme;
  return effective === 'dark' ? darkTheme : lightTheme;
}
