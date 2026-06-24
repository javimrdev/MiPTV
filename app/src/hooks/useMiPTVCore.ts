import { useCallback, useRef } from 'react';
import NativeMiPTVCore, {
  type Channel,
  type EpgEntry,
  type Playlist,
  type Provider,
} from '../specs/NativeMiPTVCore';

let initialized = false;

async function ensureInit() {
  if (initialized) return;
  await NativeMiPTVCore.init('miptv.db');
  initialized = true;
}

export function useMiPTVCore() {
  const initRef = useRef<Promise<void> | null>(null);

  const ready = useCallback(async () => {
    if (!initRef.current) {
      initRef.current = ensureInit();
    }
    return initRef.current;
  }, []);

  const listProviders = useCallback(async (): Promise<Provider[]> => {
    await ready();
    return NativeMiPTVCore.listProviders();
  }, [ready]);

  const addProvider = useCallback(
    async (provider: Provider): Promise<void> => {
      await ready();
      return NativeMiPTVCore.addProvider(provider);
    },
    [ready],
  );

  const deleteProvider = useCallback(
    async (id: string): Promise<void> => {
      await ready();
      return NativeMiPTVCore.deleteProvider(id);
    },
    [ready],
  );

  const syncProvider = useCallback(
    async (providerId: string): Promise<number> => {
      await ready();
      return NativeMiPTVCore.syncProvider(providerId);
    },
    [ready],
  );

  const listChannels = useCallback(
    async (providerId: string): Promise<Channel[]> => {
      await ready();
      return NativeMiPTVCore.listChannels(providerId);
    },
    [ready],
  );

  const searchChannels = useCallback(
    async (query: string): Promise<Channel[]> => {
      await ready();
      return NativeMiPTVCore.searchChannels(query);
    },
    [ready],
  );

  const getCurrentEpg = useCallback(
    async (channelId: string): Promise<EpgEntry | null> => {
      await ready();
      return NativeMiPTVCore.getCurrentEpg(channelId);
    },
    [ready],
  );

  const getEpgForChannel = useCallback(
    async (channelId: string, start: number, end: number): Promise<EpgEntry[]> => {
      await ready();
      return NativeMiPTVCore.getEpgForChannel(channelId, start, end);
    },
    [ready],
  );

  const createPlaylist = useCallback(
    async (playlist: Playlist): Promise<void> => {
      await ready();
      return NativeMiPTVCore.createPlaylist(playlist);
    },
    [ready],
  );

  const listPlaylists = useCallback(async (): Promise<Playlist[]> => {
    await ready();
    return NativeMiPTVCore.listPlaylists();
  }, [ready]);

  const deletePlaylist = useCallback(
    async (id: string): Promise<void> => {
      await ready();
      return NativeMiPTVCore.deletePlaylist(id);
    },
    [ready],
  );

  const recordWatch = useCallback(
    async (channelId: string, startedAt: number, durationSeconds: number): Promise<void> => {
      await ready();
      return NativeMiPTVCore.recordWatch(channelId, startedAt, durationSeconds);
    },
    [ready],
  );

  return {
    listProviders,
    addProvider,
    deleteProvider,
    syncProvider,
    listChannels,
    searchChannels,
    getCurrentEpg,
    getEpgForChannel,
    createPlaylist,
    listPlaylists,
    deletePlaylist,
    recordWatch,
  };
}
