import React, { useCallback } from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import { useFavouritesStore } from '../store/favouritesStore';
import { useTheme } from '../theme/useTheme';

type FavouriteButtonProps = {
  channelId: string;
  size?: number;
};

export function FavouriteButton({ channelId, size = 24 }: FavouriteButtonProps) {
  const theme = useTheme();
  const isFavourite = useFavouritesStore(s => s.isFavourite(channelId));
  const toggle = useFavouritesStore(s => s.toggleFavourite);

  const handlePress = useCallback(() => toggle(channelId), [toggle, channelId]);

  return (
    <TouchableOpacity onPress={handlePress} style={styles.btn} hitSlop={8}>
      <Text style={[styles.icon, { fontSize: size, color: isFavourite ? theme.colors.warning : theme.colors.textDisabled }]}>
        {isFavourite ? '★' : '☆'}
      </Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  btn: { padding: 4 },
  icon: { lineHeight: 28 },
});
