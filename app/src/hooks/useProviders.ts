import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';
import type { Provider } from '../specs/NativeMiPTVCore';

export const PROVIDERS_KEY = ['providers'] as const;

export function useProviders() {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: PROVIDERS_KEY,
    queryFn: () => core.listProviders(),
  });
}

export function useAddProvider() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (provider: Provider) => core.addProvider(provider),
    onSuccess: () => client.invalidateQueries({ queryKey: PROVIDERS_KEY }),
  });
}

export function useDeleteProvider() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => core.deleteProvider(id),
    onSuccess: () => client.invalidateQueries({ queryKey: PROVIDERS_KEY }),
  });
}

export function useSyncProvider() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (providerId: string) => core.syncProvider(providerId),
    onSuccess: (_count, providerId) =>
      client.invalidateQueries({ queryKey: ['channels', providerId] }),
  });
}
