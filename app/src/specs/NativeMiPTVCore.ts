import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

// ── Domain types ──────────────────────────────────────────────────────────────

export type Provider = {
  id: string;
  name: string;
  providerType: string;
  url: string;
  username: string | null;
  password: string | null;
  epgUrl: string | null;
  lastSync: number;
  isActive: boolean;
};

export type Channel = {
  id: string;
  providerId: string;
  name: string;
  streamUrl: string;
  logoUrl: string | null;
  group: string;
  country: string | null;
  tvgId: string | null;
  catchupSupport: boolean;
};

export type EpgEntry = {
  channelId: string;
  title: string;
  description: string | null;
  start: number;
  end: number;
  category: string | null;
  posterUrl: string | null;
};

export type Playlist = {
  id: string;
  name: string;
  channelIds: string[];
  createdAt: number;
  isFavorites: boolean;
};

// ── Turbo Module spec ─────────────────────────────────────────────────────────

export interface Spec extends TurboModule {
  initialize(dbPath: string): Promise<void>;

  addProvider(provider: Provider): Promise<void>;
  listProviders(): Promise<Provider[]>;
  deleteProvider(id: string): Promise<void>;
  syncProvider(providerId: string): Promise<number>;

  listChannels(providerId: string): Promise<Channel[]>;
  searchChannels(query: string): Promise<Channel[]>;

  syncEpg(providerId: string): Promise<number>;
  getCurrentEpg(channelId: string): Promise<EpgEntry | null>;
  getEpgForChannel(
    channelId: string,
    start: number,
    end: number,
  ): Promise<EpgEntry[]>;

  createPlaylist(playlist: Playlist): Promise<void>;
  listPlaylists(): Promise<Playlist[]>;
  updatePlaylist(playlist: Playlist): Promise<void>;
  deletePlaylist(id: string): Promise<void>;

  recordWatch(
    channelId: string,
    startedAt: number,
    durationSeconds: number,
  ): Promise<void>;

  getRecentlyWatched(limit: number): Promise<Channel[]>;
  getMostWatched(limit: number): Promise<Channel[]>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('NativeMiPTVCore');
