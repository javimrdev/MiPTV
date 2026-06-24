import { create } from 'zustand';

type FavouritesState = {
  favouriteIds: Set<string>;
  toggleFavourite: (channelId: string) => void;
  isFavourite: (channelId: string) => boolean;
};

export const useFavouritesStore = create<FavouritesState>((set, get) => ({
  favouriteIds: new Set(),
  toggleFavourite: channelId =>
    set(state => {
      const next = new Set(state.favouriteIds);
      if (next.has(channelId)) {
        next.delete(channelId);
      } else {
        next.add(channelId);
      }
      return { favouriteIds: next };
    }),
  isFavourite: channelId => get().favouriteIds.has(channelId),
}));
