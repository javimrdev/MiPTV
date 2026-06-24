import type { BottomTabScreenProps } from '@react-navigation/bottom-tabs';
import type { StackScreenProps } from '@react-navigation/stack';
import type { CompositeScreenProps } from '@react-navigation/native';

// ── Bottom tab params ─────────────────────────────────────────────────────────

export type TabParamList = {
  HomeTab: undefined;
  ChannelsTab: undefined;
  EPGTab: undefined;
  PlaylistsTab: undefined;
  SettingsTab: undefined;
};

// ── Root stack params ─────────────────────────────────────────────────────────

export type RootStackParamList = {
  Main: undefined;
  Player: { channelId: string; streamUrl: string; channelName: string };
  ProviderAdd: undefined;
  ProviderList: undefined;
  ChannelSearch: undefined;
  PlaylistDetail: { playlistId: string; name: string };
  EpgDetail: { channelId: string; channelName: string };
};

// ── Screen prop helpers ───────────────────────────────────────────────────────

export type RootStackScreenProps<T extends keyof RootStackParamList> =
  StackScreenProps<RootStackParamList, T>;

export type TabScreenProps<T extends keyof TabParamList> = CompositeScreenProps<
  BottomTabScreenProps<TabParamList, T>,
  RootStackScreenProps<'Main'>
>;
