import { useQuery } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';

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
