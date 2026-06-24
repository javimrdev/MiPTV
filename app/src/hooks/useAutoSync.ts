import { useEffect, useRef } from 'react';
import { useMiPTVCore } from './useMiPTVCore';
import { useSyncStore } from '../store/syncStore';
import { useQueryClient } from '@tanstack/react-query';
import type { Provider } from '../specs/NativeMiPTVCore';

const STALE_THRESHOLD_MS = 30 * 60 * 1000;

export function useAutoSync(providers: Provider[]) {
  const core = useMiPTVCore();
  const { startSync, finishSync, failSync, providers: syncStates } = useSyncStore();
  const queryClient = useQueryClient();
  const syncedRef = useRef<Set<string>>(new Set());

  useEffect(() => {
    if (providers.length === 0) {
      return;
    }

    const stale = providers.filter(p => {
      if (!p.isActive) {
        return false;
      }
      if (syncedRef.current.has(p.id)) {
        return false;
      }
      const state = syncStates[p.id];
      if (state?.status === 'syncing') {
        return false;
      }
      const lastSync = p.lastSync * 1000;
      return Date.now() - lastSync > STALE_THRESHOLD_MS;
    });

    stale.forEach(provider => {
      syncedRef.current.add(provider.id);
      startSync(provider.id);

      core
        .syncProvider(provider.id)
        .then(count => {
          finishSync(provider.id, count);
          queryClient.invalidateQueries({ queryKey: ['channels', provider.id] });
          queryClient.invalidateQueries({ queryKey: ['providers'] });
        })
        .catch((err: unknown) => {
          failSync(provider.id, String(err));
          syncedRef.current.delete(provider.id);
        });
    });
  }, [providers, syncStates, core, startSync, finishSync, failSync, queryClient]);
}
