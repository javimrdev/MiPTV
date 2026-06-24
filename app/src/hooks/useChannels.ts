import { useQuery } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';

export function useChannels(providerId: string) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: ['channels', providerId],
    queryFn: () => core.listChannels(providerId),
    enabled: !!providerId,
  });
}

export function useChannelSearch(query: string) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: ['channels', 'search', query],
    queryFn: () => core.searchChannels(query),
    enabled: query.length >= 2,
  });
}
