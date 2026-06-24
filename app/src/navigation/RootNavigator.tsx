import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';

import { TabNavigator } from './TabNavigator';
import { PlayerScreen } from '../screens/PlayerScreen';
import { ProviderAddScreen } from '../screens/ProviderAddScreen';
import { ProviderListScreen } from '../screens/ProviderListScreen';
import { ChannelSearchScreen } from '../screens/ChannelSearchScreen';
import { PlaylistDetailScreen } from '../screens/PlaylistDetailScreen';
import { EpgDetailScreen } from '../screens/EpgDetailScreen';
import type { RootStackParamList } from './types';

const Stack = createStackNavigator<RootStackParamList>();

export function RootNavigator() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Main" component={TabNavigator} options={{ headerShown: false }} />
      <Stack.Screen name="Player" component={PlayerScreen} options={{ headerShown: false, presentation: 'modal' }} />
      <Stack.Screen name="ProviderAdd" component={ProviderAddScreen} options={{ title: 'Add Provider' }} />
      <Stack.Screen name="ProviderList" component={ProviderListScreen} options={{ title: 'Providers' }} />
      <Stack.Screen name="ChannelSearch" component={ChannelSearchScreen} options={{ title: 'Search' }} />
      <Stack.Screen name="PlaylistDetail" component={PlaylistDetailScreen} options={{ title: 'Playlist' }} />
      <Stack.Screen name="EpgDetail" component={EpgDetailScreen} options={{ title: 'Programme Guide' }} />
    </Stack.Navigator>
  );
}
