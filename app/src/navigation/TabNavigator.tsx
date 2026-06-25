import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

import { HomeScreen } from '../screens/HomeScreen';
import { ChannelsScreen } from '../screens/ChannelsScreen';
import { EPGScreen } from '../screens/EPGScreen';
import { PlaylistsScreen } from '../screens/PlaylistsScreen';
import { SettingsScreen } from '../screens/SettingsScreen';
import { HomeIcon, ChannelsIcon, EPGIcon, PlaylistsIcon, SettingsIcon } from './TabIcons';
import type { TabParamList } from './types';

const Tab = createBottomTabNavigator<TabParamList>();

export function TabNavigator() {
  return (
    <Tab.Navigator screenOptions={{ headerShown: false }}>
      <Tab.Screen
        name="HomeTab"
        component={HomeScreen}
        options={{ title: 'Home', tabBarIcon: ({ color, size }) => <HomeIcon color={color} size={size} /> }}
      />
      <Tab.Screen
        name="ChannelsTab"
        component={ChannelsScreen}
        options={{ title: 'Channels', tabBarIcon: ({ color, size }) => <ChannelsIcon color={color} size={size} /> }}
      />
      <Tab.Screen
        name="EPGTab"
        component={EPGScreen}
        options={{ title: 'EPG', tabBarIcon: ({ color, size }) => <EPGIcon color={color} size={size} /> }}
      />
      <Tab.Screen
        name="PlaylistsTab"
        component={PlaylistsScreen}
        options={{ title: 'Playlists', tabBarIcon: ({ color, size }) => <PlaylistsIcon color={color} size={size} /> }}
      />
      <Tab.Screen
        name="SettingsTab"
        component={SettingsScreen}
        options={{ title: 'Settings', tabBarIcon: ({ color, size }) => <SettingsIcon color={color} size={size} /> }}
      />
    </Tab.Navigator>
  );
}
