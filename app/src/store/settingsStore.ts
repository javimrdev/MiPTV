import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import i18n, { type SupportedLanguage } from '../i18n';

export type ThemeSetting = 'system' | 'light' | 'dark';

type SettingsState = {
  theme: ThemeSetting;
  language: SupportedLanguage | 'auto';
  parentalPinEnabled: boolean;
  setTheme: (theme: ThemeSetting) => void;
  setLanguage: (lang: SupportedLanguage | 'auto') => void;
  setParentalPinEnabled: (enabled: boolean) => void;
};

const STORAGE_KEY = 'miptv_settings';

export const useSettingsStore = create<SettingsState>((set, get) => ({
  theme: 'system',
  language: 'auto',
  parentalPinEnabled: false,

  setTheme: (theme) => {
    set({ theme });
    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify({ ...get(), theme })).catch(() => {});
  },

  setLanguage: (language) => {
    set({ language });
    if (language !== 'auto') {
      i18n.changeLanguage(language).catch(() => {});
    }
    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify({ ...get(), language })).catch(() => {});
  },

  setParentalPinEnabled: (enabled) => {
    set({ parentalPinEnabled: enabled });
    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify({ ...get(), parentalPinEnabled: enabled })).catch(() => {});
  },
}));

// Load persisted settings on startup
AsyncStorage.getItem(STORAGE_KEY)
  .then((raw) => {
    if (!raw) { return; }
    const saved = JSON.parse(raw) as Partial<SettingsState>;
    const language = saved.language ?? 'auto';
    useSettingsStore.setState({
      theme: saved.theme ?? 'system',
      language,
      parentalPinEnabled: saved.parentalPinEnabled ?? false,
    });
    if (language !== 'auto') {
      i18n.changeLanguage(language).catch(() => {});
    }
  })
  .catch(() => {});
