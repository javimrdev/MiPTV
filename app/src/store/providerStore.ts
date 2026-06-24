import { create } from 'zustand';
import type { Provider } from '../specs/NativeMiPTVCore';

type ProviderState = {
  providers: Provider[];
  activeProviderId: string | null;
  setProviders: (providers: Provider[]) => void;
  setActiveProvider: (id: string | null) => void;
};

export const useProviderStore = create<ProviderState>(set => ({
  providers: [],
  activeProviderId: null,
  setProviders: providers => set({ providers }),
  setActiveProvider: id => set({ activeProviderId: id }),
}));
