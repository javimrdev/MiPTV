import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

import { HomeScreen } from '../screens/HomeScreen';
import { ChannelsScreen } from '../screens/ChannelsScreen';
import { EPGScreen } from '../screens/EPGScreen';
import { PlaylistsScreen } from '../screens/PlaylistsScreen';
import { SettingsScreen } from '../screens/SettingsScreen';
import type { TabParamList } from './types';

const Tab = createBottomTabNavigator<TabParamList>();

export function TabNavigator() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen name="HomeTab" component={HomeScreen} options={{ title: 'Home' }} />
      <Tab.Screen name="ChannelsTab" component={ChannelsScreen} options={{ title: 'Channels' }} />
      <Tab.Screen name="EPGTab" component={EPGScreen} options={{ title: 'EPG' }} />
      <Tab.Screen name="PlaylistsTab" component={PlaylistsScreen} options={{ title: 'Playlists' }} />
      <Tab.Screen name="SettingsTab" component={SettingsScreen} options={{ title: 'Settings' }} />
    </Tab.Navigator>
  );
}
