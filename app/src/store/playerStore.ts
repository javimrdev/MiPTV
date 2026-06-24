import { create } from 'zustand';
import type { Channel } from '../specs/NativeMiPTVCore';

type PlayerState = {
  currentChannel: Channel | null;
  isPlaying: boolean;
  isMuted: boolean;
  volume: number;
  setChannel: (channel: Channel | null) => void;
  setPlaying: (playing: boolean) => void;
  toggleMute: () => void;
  setVolume: (volume: number) => void;
};

export const usePlayerStore = create<PlayerState>(set => ({
  currentChannel: null,
  isPlaying: false,
  isMuted: false,
  volume: 1,
  setChannel: channel => set({ currentChannel: channel, isPlaying: channel !== null }),
  setPlaying: playing => set({ isPlaying: playing }),
  toggleMute: () => set(state => ({ isMuted: !state.isMuted })),
  setVolume: volume => set({ volume }),
}));
