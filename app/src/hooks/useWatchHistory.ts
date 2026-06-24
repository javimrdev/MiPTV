import { useQuery } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';

export const WATCH_HISTORY_KEY = ['watch_history'] as const;

export function useRecentlyWatched(limit = 20) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: [...WATCH_HISTORY_KEY, 'recent', limit],
    queryFn: () => core.getRecentlyWatched(limit),
  });
}

export function useMostWatched(limit = 20) {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: [...WATCH_HISTORY_KEY, 'most', limit],
    queryFn: () => core.getMostWatched(limit),
  });
}
