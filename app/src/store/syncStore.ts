import { create } from 'zustand';

type SyncStatus = 'idle' | 'syncing' | 'success' | 'error';

type ProviderSyncState = {
  status: SyncStatus;
  channelsFound: number;
  error: string | null;
  lastSyncAt: number | null;
};

type SyncState = {
  providers: Record<string, ProviderSyncState>;
  startSync: (providerId: string) => void;
  finishSync: (providerId: string, channelsFound: number) => void;
  failSync: (providerId: string, error: string) => void;
  getStatus: (providerId: string) => SyncStatus;
};

const defaultProviderState: ProviderSyncState = {
  status: 'idle',
  channelsFound: 0,
  error: null,
  lastSyncAt: null,
};

export const useSyncStore = create<SyncState>((set, get) => ({
  providers: {},
  startSync: providerId =>
    set(state => ({
      providers: {
        ...state.providers,
        [providerId]: { ...defaultProviderState, status: 'syncing' },
      },
    })),
  finishSync: (providerId, channelsFound) =>
    set(state => ({
      providers: {
        ...state.providers,
        [providerId]: { status: 'success', channelsFound, error: null, lastSyncAt: Date.now() },
      },
    })),
  failSync: (providerId, error) =>
    set(state => ({
      providers: {
        ...state.providers,
        [providerId]: { ...defaultProviderState, status: 'error', error },
      },
    })),
  getStatus: providerId => get().providers[providerId]?.status ?? 'idle',
}));
