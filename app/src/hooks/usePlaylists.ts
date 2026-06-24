import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useMiPTVCore } from './useMiPTVCore';
import type { Playlist } from '../specs/NativeMiPTVCore';

export const PLAYLISTS_KEY = ['playlists'] as const;

export function usePlaylists() {
  const core = useMiPTVCore();
  return useQuery({
    queryKey: PLAYLISTS_KEY,
    queryFn: () => core.listPlaylists(),
  });
}

export function useCreatePlaylist() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (playlist: Playlist) => core.createPlaylist(playlist),
    onSuccess: () => client.invalidateQueries({ queryKey: PLAYLISTS_KEY }),
  });
}

export function useUpdatePlaylist() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (playlist: Playlist) => core.updatePlaylist(playlist),
    onSuccess: () => client.invalidateQueries({ queryKey: PLAYLISTS_KEY }),
  });
}

export function useDeletePlaylist() {
  const core = useMiPTVCore();
  const client = useQueryClient();
  return useMutation({
    mutationFn: (id: string) => core.deletePlaylist(id),
    onSuccess: () => client.invalidateQueries({ queryKey: PLAYLISTS_KEY }),
  });
}
