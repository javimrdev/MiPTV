import React from 'react';
import { View } from 'react-native';

type IconProps = { color: string; size: number };

export function HomeIcon({ color, size }: IconProps) {
  const roofW = size * 0.9;
  const roofH = size * 0.44;
  const bodyW = size * 0.65;
  const bodyH = size * 0.42;
  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center' }}>
      <View
        style={{
          width: 0,
          height: 0,
          borderLeftWidth: roofW / 2,
          borderRightWidth: roofW / 2,
          borderBottomWidth: roofH,
          borderLeftColor: 'transparent',
          borderRightColor: 'transparent',
          borderBottomColor: color,
        }}
      />
      <View style={{ width: bodyW, height: bodyH, backgroundColor: color }} />
    </View>
  );
}

export function ChannelsIcon({ color, size }: IconProps) {
  const screenW = size * 0.85;
  const screenH = size * 0.62;
  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center' }}>
      <View
        style={{
          width: screenW,
          height: screenH,
          borderRadius: 3,
          borderWidth: 2,
          borderColor: color,
        }}
      />
      <View style={{ width: 2, height: size * 0.18, backgroundColor: color }} />
      <View style={{ width: size * 0.42, height: 2, backgroundColor: color, borderRadius: 1 }} />
    </View>
  );
}

export function EPGIcon({ color, size }: IconProps) {
  const calW = size * 0.82;
  const calH = size * 0.76;
  const headerH = calH * 0.28;
  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center' }}>
      <View
        style={{
          width: calW,
          height: calH,
          borderRadius: 2,
          borderWidth: 2,
          borderColor: color,
          overflow: 'hidden',
        }}
      >
        <View style={{ width: '100%', height: headerH, backgroundColor: color }} />
        {[0, 1].map(row => (
          <View
            key={row}
            style={{ flex: 1, flexDirection: 'row', justifyContent: 'space-around', alignItems: 'center', paddingHorizontal: 3 }}
          >
            {[0, 1, 2].map(col => (
              <View key={col} style={{ width: 3, height: 3, borderRadius: 1.5, backgroundColor: color }} />
            ))}
          </View>
        ))}
      </View>
    </View>
  );
}

export function PlaylistsIcon({ color, size }: IconProps) {
  const lineH = 2;
  const gap = size * 0.2;
  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center', gap }}>
      <View style={{ width: size * 0.8, height: lineH, backgroundColor: color, borderRadius: 1 }} />
      <View style={{ width: size * 0.8, height: lineH, backgroundColor: color, borderRadius: 1 }} />
      <View style={{ width: size * 0.8, height: lineH, backgroundColor: color, borderRadius: 1 }} />
    </View>
  );
}

export function SettingsIcon({ color, size }: IconProps) {
  const lineH = 2;
  const dotSize = size * 0.22;
  const gap = size * 0.2;
  return (
    <View style={{ width: size, height: size, alignItems: 'center', justifyContent: 'center', gap }}>
      <View style={{ width: size * 0.8, flexDirection: 'row', alignItems: 'center', gap: size * 0.12 }}>
        <View style={{ width: dotSize, height: dotSize, borderRadius: dotSize / 2, borderWidth: 2, borderColor: color }} />
        <View style={{ flex: 1, height: lineH, backgroundColor: color, borderRadius: 1 }} />
      </View>
      <View style={{ width: size * 0.8, flexDirection: 'row', alignItems: 'center', gap: size * 0.12 }}>
        <View style={{ flex: 1, height: lineH, backgroundColor: color, borderRadius: 1 }} />
        <View style={{ width: dotSize, height: dotSize, borderRadius: dotSize / 2, borderWidth: 2, borderColor: color }} />
      </View>
      <View style={{ width: size * 0.8, flexDirection: 'row', alignItems: 'center', gap: size * 0.12 }}>
        <View style={{ width: dotSize, height: dotSize, borderRadius: dotSize / 2, borderWidth: 2, borderColor: color }} />
        <View style={{ flex: 1, height: lineH, backgroundColor: color, borderRadius: 1 }} />
      </View>
    </View>
  );
}
