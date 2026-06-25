import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';

export type ThemeSetting = 'system' | 'light' | 'dark';

type SettingsState = {
  theme: ThemeSetting;
  parentalPinEnabled: boolean;
  setTheme: (theme: ThemeSetting) => void;
  setParentalPinEnabled: (enabled: boolean) => void;
};

const STORAGE_KEY = 'miptv_settings';

export const useSettingsStore = create<SettingsState>((set, get) => ({
  theme: 'system',
  parentalPinEnabled: false,

  setTheme: (theme) => {
    set({ theme });
    AsyncStorage.setItem(STORAGE_KEY, JSON.stringify({ ...get(), theme })).catch(() => {});
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
    useSettingsStore.setState({
      theme: saved.theme ?? 'system',
      parentalPinEnabled: saved.parentalPinEnabled ?? false,
    });
  })
  .catch(() => {});
