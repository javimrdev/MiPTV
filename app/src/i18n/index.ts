import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import { NativeModules, Platform, I18nManager } from 'react-native';
import en from './translations/en';
import es from './translations/es';
import fr from './translations/fr';
import de from './translations/de';
import pt from './translations/pt';

export const SUPPORTED_LANGUAGES = ['en', 'es', 'fr', 'de', 'pt'] as const;
export type SupportedLanguage = (typeof SUPPORTED_LANGUAGES)[number];

function detectDeviceLocale(): string {
  if (Platform.OS === 'ios') {
    const locale =
      (NativeModules.SettingsManager?.settings?.AppleLocale as string | undefined) ||
      (NativeModules.SettingsManager?.settings?.AppleLanguages?.[0] as string | undefined) ||
      'en';
    return locale.split('_')[0].split('-')[0];
  }
  if (Platform.OS === 'android') {
    return ((NativeModules.I18nManager?.localeIdentifier as string | undefined) || 'en').split('_')[0];
  }
  return (typeof navigator !== 'undefined' && navigator.language?.split('-')[0]) || 'en';
}

export function isSupportedLanguage(lang: string): lang is SupportedLanguage {
  return (SUPPORTED_LANGUAGES as readonly string[]).includes(lang);
}

const detectedLocale = detectDeviceLocale();
const initialLng = isSupportedLanguage(detectedLocale) ? detectedLocale : 'en';

// RTL stub — enable when adding Arabic/Hebrew
I18nManager.forceRTL(false);

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: en },
    es: { translation: es },
    fr: { translation: fr },
    de: { translation: de },
    pt: { translation: pt },
  },
  lng: initialLng,
  fallbackLng: 'en',
  interpolation: { escapeValue: false },
  compatibilityJSON: 'v4',
});

export default i18n;
