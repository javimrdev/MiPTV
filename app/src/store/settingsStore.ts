import { create } from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';
import i18n, { type SupportedLanguage } from '../i18n';

export type ThemeSetting = 'system' | 'light' | 'dark';
export type PreferredPlayer = 'internal' | 'vlc';
export type NetworkQuality = 'auto' | 'low' | 'medium' | 'high';
export type EpgCacheTtlHours = 1 | 6 | 12 | 24 | 48;

type SettingsState = {
  theme: ThemeSetting;
  language: SupportedLanguage | 'auto';
  parentalPinEnabled: boolean;
  parentalPin: string | null;
  proxyUrl: string | null;
  preferredPlayer: PreferredPlayer;
  epgCacheTtlHours: EpgCacheTtlHours;
  networkQuality: NetworkQuality;
  autoPlayLastChannel: boolean;
  setTheme: (theme: ThemeSetting) => void;
  setLanguage: (lang: SupportedLanguage | 'auto') => void;
  setParentalPinEnabled: (enabled: boolean) => void;
  setParentalPin: (pin: string | null) => void;
  setProxyUrl: (url: string | null) => void;
  setPreferredPlayer: (player: PreferredPlayer) => void;
  setEpgCacheTtlHours: (hours: EpgCacheTtlHours) => void;
  setNetworkQuality: (quality: NetworkQuality) => void;
  setAutoPlayLastChannel: (enabled: boolean) => void;
};

const STORAGE_KEY = 'miptv_settings';

type PersistedData = Omit<SettingsState,
  'setTheme' | 'setLanguage' | 'setParentalPinEnabled' | 'setParentalPin' |
  'setProxyUrl' | 'setPreferredPlayer' | 'setEpgCacheTtlHours' |
  'setNetworkQuality' | 'setAutoPlayLastChannel'
>;

function persist(state: SettingsState) {
  const data: PersistedData = {
    theme: state.theme,
    language: state.language,
    parentalPinEnabled: state.parentalPinEnabled,
    parentalPin: state.parentalPin,
    proxyUrl: state.proxyUrl,
    preferredPlayer: state.preferredPlayer,
    epgCacheTtlHours: state.epgCacheTtlHours,
    networkQuality: state.networkQuality,
    autoPlayLastChannel: state.autoPlayLastChannel,
  };
  AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(data)).catch(() => {});
}

export const useSettingsStore = create<SettingsState>((set, get) => ({
  theme: 'system',
  language: 'auto',
  parentalPinEnabled: false,
  parentalPin: null,
  proxyUrl: null,
  preferredPlayer: 'internal',
  epgCacheTtlHours: 12,
  networkQuality: 'auto',
  autoPlayLastChannel: false,

  setTheme: (theme) => { set({ theme }); persist(get()); },
  setLanguage: (language) => {
    set({ language });
    if (language !== 'auto') { i18n.changeLanguage(language).catch(() => {}); }
    persist(get());
  },
  setParentalPinEnabled: (parentalPinEnabled) => { set({ parentalPinEnabled }); persist(get()); },
  setParentalPin: (parentalPin) => { set({ parentalPin }); persist(get()); },
  setProxyUrl: (proxyUrl) => { set({ proxyUrl }); persist(get()); },
  setPreferredPlayer: (preferredPlayer) => { set({ preferredPlayer }); persist(get()); },
  setEpgCacheTtlHours: (epgCacheTtlHours) => { set({ epgCacheTtlHours }); persist(get()); },
  setNetworkQuality: (networkQuality) => { set({ networkQuality }); persist(get()); },
  setAutoPlayLastChannel: (autoPlayLastChannel) => { set({ autoPlayLastChannel }); persist(get()); },
}));

// Load persisted settings on startup
AsyncStorage.getItem(STORAGE_KEY)
  .then((raw) => {
    if (!raw) { return; }
    const saved = JSON.parse(raw) as Partial<PersistedData>;
    const language = saved.language ?? 'auto';
    useSettingsStore.setState({
      theme: saved.theme ?? 'system',
      language,
      parentalPinEnabled: saved.parentalPinEnabled ?? false,
      parentalPin: saved.parentalPin ?? null,
      proxyUrl: saved.proxyUrl ?? null,
      preferredPlayer: saved.preferredPlayer ?? 'internal',
      epgCacheTtlHours: saved.epgCacheTtlHours ?? 12,
      networkQuality: saved.networkQuality ?? 'auto',
      autoPlayLastChannel: saved.autoPlayLastChannel ?? false,
    });
    if (language !== 'auto') { i18n.changeLanguage(language).catch(() => {}); }
  })
  .catch(() => {});
