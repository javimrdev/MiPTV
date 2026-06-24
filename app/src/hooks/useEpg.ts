import { useEffect, useRef } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';
import type { Provider } from '../specs/NativeMiPTVCore';

export function useCurrentEpg(channelId: string) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: ['epg', 'current', channelId],
    queryFn: () => core.getCurrentEpg(channelId),
    enabled: !!channelId,
    refetchInterval: 60_000,
  });
}

export function useEpgForChannel(channelId: string, start: number, end: number) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: ['epg', channelId, start, end],
    queryFn: () => core.getEpgForChannel(channelId, start, end),
    enabled: !!channelId,
  });
}

export function useSyncEpg() {
  const core = useMiPTVCore();
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (providerId: string) => core.syncEpg(providerId),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['epg'] }),
  });
}

// Auto-syncs EPG once per session for every active provider that has an epgUrl.
export function useAutoSyncEpg(providers: Provider[]) {
  const core = useMiPTVCore();
  const queryClient = useQueryClient();
  const syncedRef = useRef<Set<string>>(new Set());

  useEffect(() => {
    const eligible = providers.filter(p => p.isActive && !!p.epgUrl);

    eligible.forEach(provider => {
      if (syncedRef.current.has(provider.id)) { return; }
      syncedRef.current.add(provider.id);

      core
        .syncEpg(provider.id)
        .then(() => queryClient.invalidateQueries({ queryKey: ['epg'] }))
        .catch(() => syncedRef.current.delete(provider.id));
    });
  }, [providers, core, queryClient]);
}
