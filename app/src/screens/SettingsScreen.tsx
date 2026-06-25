import React, { useState } from 'react';
import {
  Alert,
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
import { PinEntryModal } from '../components/PinEntryModal';
import { useTheme } from '../theme/useTheme';
import {
  useSettingsStore,
  type ThemeSetting,
  type PreferredPlayer,
  type EpgCacheTtlHours,
  type NetworkQuality,
} from '../store/settingsStore';
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

const EPG_TTL_OPTIONS: EpgCacheTtlHours[] = [1, 6, 12, 24, 48];
const NETWORK_QUALITY_OPTIONS: NetworkQuality[] = ['auto', 'low', 'medium', 'high'];
const PLAYER_OPTIONS: PreferredPlayer[] = ['internal', 'vlc'];

export function SettingsScreen({ navigation }: TabScreenProps<'SettingsTab'>) {
  const { t } = useTranslation();
  const theme = useTheme();
  const {
    theme: themeSetting, setTheme,
    language, setLanguage,
    parentalPinEnabled, setParentalPinEnabled,
    parentalPin, setParentalPin,
    proxyUrl, setProxyUrl,
    preferredPlayer, setPreferredPlayer,
    epgCacheTtlHours, setEpgCacheTtlHours,
    networkQuality, setNetworkQuality,
    autoPlayLastChannel, setAutoPlayLastChannel,
  } = useSettingsStore();

  const [pinModalVisible, setPinModalVisible] = useState(false);

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

  const nextEpgTtl = (): EpgCacheTtlHours => {
    const idx = EPG_TTL_OPTIONS.indexOf(epgCacheTtlHours);
    return EPG_TTL_OPTIONS[(idx + 1) % EPG_TTL_OPTIONS.length] ?? 12;
  };

  const nextNetworkQuality = (): NetworkQuality => {
    const idx = NETWORK_QUALITY_OPTIONS.indexOf(networkQuality);
    return NETWORK_QUALITY_OPTIONS[(idx + 1) % NETWORK_QUALITY_OPTIONS.length] ?? 'auto';
  };

  const nextPlayer = (): PreferredPlayer => {
    const idx = PLAYER_OPTIONS.indexOf(preferredPlayer);
    return PLAYER_OPTIONS[(idx + 1) % PLAYER_OPTIONS.length] ?? 'internal';
  };

  const handlePinSave = (pin: string) => {
    setParentalPin(pin);
    setPinModalVisible(false);
    Alert.alert(t('settings.pinEntry'), parentalPin ? t('settings.pinChanged') : t('settings.pinSet'));
  };

  const handleProxyUrl = () => {
    Alert.prompt(
      t('settings.proxyUrl'),
      'http://proxy:port',
      (text) => setProxyUrl(text.trim() || null),
      'plain-text',
      proxyUrl ?? '',
    );
  };

  const networkQualityLabels: Record<NetworkQuality, string> = {
    auto: t('settings.streamQualityAuto'),
    low: 'Low',
    medium: 'Medium',
    high: 'High',
  };

  return (
    <>
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
            <SettingRow
              label={t('settings.changePin')}
              onPress={() => setPinModalVisible(true)}
              value={parentalPin ? '••••' : '—'}
            />
          )}
        </Section>

        <Section title={t('settings.network')}>
          <SettingRow
            label={t('settings.streamQuality')}
            value={networkQualityLabels[networkQuality]}
            onPress={() => setNetworkQuality(nextNetworkQuality())}
          />
          <SettingRow
            label={t('settings.proxyUrl')}
            value={proxyUrl ?? t('settings.proxyUrlNone')}
            onPress={Platform.OS === 'ios' ? handleProxyUrl : undefined}
          />
        </Section>

        <Section title="Playback">
          <SettingRow
            label={t('settings.preferredPlayer')}
            value={preferredPlayer === 'internal' ? t('settings.playerInternal') : t('settings.playerVlc')}
            onPress={() => setPreferredPlayer(nextPlayer())}
          />
          <SettingRow
            label={t('settings.epgCacheTtl')}
            value={`${epgCacheTtlHours}h`}
            onPress={() => setEpgCacheTtlHours(nextEpgTtl())}
          />
          <SettingRow label={t('settings.autoPlayLastChannel')}>
            <Switch
              value={autoPlayLastChannel}
              onValueChange={setAutoPlayLastChannel}
              trackColor={{ true: theme.colors.primary }}
            />
          </SettingRow>
        </Section>

        <Section title={t('settings.about')}>
          <SettingRow label={t('settings.version')} value={APP_VERSION} />
          <SettingRow label={t('settings.build')} value="React Native + Rust" />
        </Section>
      </ScrollView>

      <PinEntryModal
        visible={pinModalVisible}
        onClose={() => setPinModalVisible(false)}
        onSave={handlePinSave}
        title={t('settings.changePin')}
      />
    </>
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
