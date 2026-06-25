import React, { useState, type ReactNode, type CSSProperties } from 'react';

type TVFocusableProps = {
  children?: ReactNode;
  onPress?: () => void;
  style?: CSSProperties;
  hasTVPreferredFocus?: boolean;
};

const focusRingStyle: CSSProperties = {
  outline: '3px solid #007AFF',
  outlineOffset: '2px',
};

export function TVFocusable({ children, onPress, style, hasTVPreferredFocus }: TVFocusableProps) {
  const [focused, setFocused] = useState(false);

  return (
    <div
      role="button"
      tabIndex={0}
      // eslint-disable-next-line react-native/no-inline-styles
      style={{
        cursor: 'pointer',
        ...(focused ? focusRingStyle : {}),
        ...(style as object | undefined),
      }}
      onFocus={() => setFocused(true)}
      onBlur={() => setFocused(false)}
      onClick={onPress}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onPress?.();
        }
      }}
      autoFocus={hasTVPreferredFocus}
    >
      {children}
    </div>
  );
}
