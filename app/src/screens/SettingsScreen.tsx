import React from 'react';
import {
  Platform,
  ScrollView,
  StyleSheet,
  Switch,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useTranslation } from 'react-i18next';
import { TVFocusable } from '../components/TVFocusable';
import { useTheme } from '../theme/useTheme';
import { useSettingsStore, type ThemeSetting } from '../store/settingsStore';
import { SUPPORTED_LANGUAGES, type SupportedLanguage } from '../i18n';
import type { TabScreenProps } from '../navigation/types';

const APP_VERSION = '0.1.0';

type SettingRowProps = {
  label: string;
  value?: string;
  onPress?: () => void;
  children?: React.ReactNode;
  hasTVPreferredFocus?: boolean;
};

function SettingRow({ label, value, onPress, children, hasTVPreferredFocus }: SettingRowProps) {
  const theme = useTheme();
  const inner = (
    <View style={[styles.row, { borderBottomColor: theme.colors.border }]}>
      <Text style={[styles.rowLabel, { color: theme.colors.text }]}>{label}</Text>
      <View style={styles.rowRight}>
        {value !== undefined && (
          <Text style={[styles.rowValue, { color: theme.colors.textSecondary }]}>{value}</Text>
        )}
        {children}
        {onPress && !children && (
          <Text style={[styles.chevron, { color: theme.colors.textSecondary }]}>›</Text>
        )}
      </View>
    </View>
  );

  if (onPress) {
    if (Platform.isTV) {
      return (
        <TVFocusable onPress={onPress} hasTVPreferredFocus={hasTVPreferredFocus}>
          {inner}
        </TVFocusable>
      );
    }
    return (
      <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
        {inner}
      </TouchableOpacity>
    );
  }
  return inner;
}

type SectionProps = {
  title: string;
  children: React.ReactNode;
};

function Section({ title, children }: SectionProps) {
  const theme = useTheme();
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: theme.colors.textSecondary }]}>{title}</Text>
      <View style={[styles.sectionBody, { backgroundColor: theme.colors.surface, borderColor: theme.colors.border }]}>
        {children}
      </View>
    </View>
  );
}

const LANGUAGE_LABELS: Record<SupportedLanguage | 'auto', string> = {
  auto: 'Auto',
  en: 'English',
  es: 'Español',
  fr: 'Français',
  de: 'Deutsch',
  pt: 'Português',
};

export function SettingsScreen({ navigation }: TabScreenProps<'SettingsTab'>) {
  const { t } = useTranslation();
  const theme = useTheme();
  const { theme: themeSetting, setTheme, language, setLanguage, parentalPinEnabled, setParentalPinEnabled } = useSettingsStore();

  const THEME_OPTIONS: { label: string; value: ThemeSetting }[] = [
    { label: t('settings.themeSystem'), value: 'system' },
    { label: t('settings.themeLight'), value: 'light' },
    { label: t('settings.themeDark'), value: 'dark' },
  ];

  const nextTheme = (): ThemeSetting => {
    const idx = THEME_OPTIONS.findIndex((o) => o.value === themeSetting);
    return THEME_OPTIONS[(idx + 1) % THEME_OPTIONS.length]?.value ?? 'system';
  };

  const themeLabel = THEME_OPTIONS.find((o) => o.value === themeSetting)?.label ?? t('settings.themeSystem');

  const allLanguages: Array<SupportedLanguage | 'auto'> = ['auto', ...SUPPORTED_LANGUAGES];

  const nextLanguage = (): SupportedLanguage | 'auto' => {
    const idx = allLanguages.indexOf(language);
    return allLanguages[(idx + 1) % allLanguages.length] ?? 'auto';
  };

  return (
    <ScrollView
      style={[styles.container, { backgroundColor: theme.colors.background }]}
      contentContainerStyle={styles.content}
    >
      <Text style={[styles.pageTitle, { color: theme.colors.text }]}>{t('settings.title')}</Text>

      <Section title={t('nav.providers')}>
        <SettingRow
          label={t('settings.manageProviders')}
          onPress={() => navigation.navigate('ProviderList')}
          hasTVPreferredFocus={Platform.isTV}
        />
      </Section>

      <Section title={t('settings.appearance')}>
        <SettingRow
          label={t('settings.theme')}
          value={themeLabel}
          onPress={() => setTheme(nextTheme())}
        />
        <SettingRow
          label={t('settings.language')}
          value={LANGUAGE_LABELS[language]}
          onPress={() => setLanguage(nextLanguage())}
        />
      </Section>

      <Section title={t('settings.parentalControls')}>
        <SettingRow label={t('settings.requirePin')}>
          <Switch
            value={parentalPinEnabled}
            onValueChange={setParentalPinEnabled}
            trackColor={{ true: theme.colors.primary }}
          />
        </SettingRow>
        {parentalPinEnabled && (
          <SettingRow label={t('settings.changePin')} onPress={() => {}} value="****" />
        )}
      </Section>

      <Section title={t('settings.network')}>
        <SettingRow label={t('settings.streamQuality')} value={t('settings.streamQualityAuto')} />
        <SettingRow label={t('settings.bufferSize')} value={t('settings.bufferSizeDefault')} />
      </Section>

      <Section title={t('settings.about')}>
        <SettingRow label={t('settings.version')} value={APP_VERSION} />
        <SettingRow label={t('settings.build')} value="React Native + Rust" />
      </Section>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  content: { paddingVertical: 16, paddingHorizontal: 0 },
  pageTitle: {
    fontSize: Platform.isTV ? 32 : 28,
    fontWeight: '700',
    marginBottom: 16,
    marginHorizontal: 20,
  },

  // Section
  section: { marginBottom: 24, marginHorizontal: 16 },
  sectionTitle: {
    fontSize: Platform.isTV ? 16 : 13,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 8,
    marginHorizontal: 4,
  },
  sectionBody: {
    borderRadius: 12,
    borderWidth: StyleSheet.hairlineWidth,
    overflow: 'hidden',
  },

  // Row
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: Platform.isTV ? 18 : 14,
    borderBottomWidth: StyleSheet.hairlineWidth,
    minHeight: Platform.isTV ? 64 : 48,
  },
  rowLabel: { flex: 1, fontSize: Platform.isTV ? 20 : 16 },
  rowRight: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  rowValue: { fontSize: Platform.isTV ? 18 : 14 },
  chevron: { fontSize: Platform.isTV ? 24 : 20, fontWeight: '300' },
});
