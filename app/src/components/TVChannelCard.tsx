import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';
import { TVFocusable } from './TVFocusable';
import type { Channel } from '../specs/NativeMiPTVCore';

type TVChannelCardProps = {
  channel: Channel;
  onPress: () => void;
  hasTVPreferredFocus?: boolean;
};

export function TVChannelCard({ channel, onPress, hasTVPreferredFocus }: TVChannelCardProps) {
  return (
    <TVFocusable
      style={styles.card}
      onPress={onPress}
      hasTVPreferredFocus={hasTVPreferredFocus}
    >
      {channel.logoUrl ? (
        <Image source={{ uri: channel.logoUrl }} style={styles.logo} resizeMode="contain" />
      ) : (
        <View style={styles.logoPlaceholder}>
          <Text style={styles.initial}>{channel.name[0] ?? '?'}</Text>
        </View>
      )}
      <Text style={styles.name} numberOfLines={2}>{channel.name}</Text>
    </TVFocusable>
  );
}

const styles = StyleSheet.create({
  card: {
    width: 160,
    marginHorizontal: 8,
    alignItems: 'center',
    borderRadius: 8,
    overflow: 'hidden',
    backgroundColor: '#1a1a2e',
    paddingBottom: 8,
  },
  logo: {
    width: 160,
    height: 90,
    backgroundColor: '#111',
  },
  logoPlaceholder: {
    width: 160,
    height: 90,
    backgroundColor: '#1a2a4a',
    alignItems: 'center',
    justifyContent: 'center',
  },
  initial: {
    color: '#fff',
    fontSize: 36,
    fontWeight: '700',
  },
  name: {
    color: '#fff',
    fontSize: 14,
    textAlign: 'center',
    marginTop: 6,
    paddingHorizontal: 6,
  },
});
