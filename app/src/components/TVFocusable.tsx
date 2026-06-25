import React, { useState } from 'react';
import {
  Platform,
  Pressable,
  StyleSheet,
  type PressableProps,
  type StyleProp,
  type ViewStyle,
} from 'react-native';

type TVFocusableProps = Omit<PressableProps, 'style'> & {
  children?: React.ReactNode;
  style?: StyleProp<ViewStyle>;
};

export function TVFocusable({ children, style, ...props }: TVFocusableProps) {
  const [tvFocused, setTvFocused] = useState(false);
  const showRing = tvFocused && Platform.isTV;

  return (
    <Pressable
      {...props}
      style={[style, showRing && styles.ring]}
      onFocus={() => setTvFocused(true)}
      onBlur={() => setTvFocused(false)}
    >
      {children}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  ring: {
    borderWidth: 3,
    borderColor: '#007AFF',
    borderRadius: 6,
  },
});
