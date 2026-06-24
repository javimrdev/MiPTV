import React, { useState, useCallback } from 'react';
import {
  View,
  Text,
  TextInput,
  ScrollView,
  TouchableOpacity,
  StyleSheet,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { useAddProvider } from '../hooks/useProviders';
import { PrimaryButton } from '../components/PrimaryButton';
import { useTheme } from '../theme/useTheme';
import type { RootStackScreenProps } from '../navigation/types';

type ProviderType = 'm3u' | 'xtream_codes' | 'mag';

const PROVIDER_TYPES: { value: ProviderType; label: string }[] = [
  { value: 'm3u', label: 'M3U URL' },
  { value: 'xtream_codes', label: 'Xtream Codes' },
  { value: 'mag', label: 'MAG Portal' },
];

export function ProviderAddScreen({ navigation }: RootStackScreenProps<'ProviderAdd'>) {
  const theme = useTheme();
  const addProvider = useAddProvider();

  const [name, setName] = useState('');
  const [providerType, setProviderType] = useState<ProviderType>('m3u');
  const [url, setUrl] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [epgUrl, setEpgUrl] = useState('');

  const needsCredentials = providerType === 'xtream_codes' || providerType === 'mag';

  const handleSave = useCallback(() => {
    if (!name.trim()) {
      Alert.alert('Validation', 'Provider name is required');
      return;
    }
    if (!url.trim()) {
      Alert.alert('Validation', 'URL is required');
      return;
    }
    if (needsCredentials && (!username.trim() || !password.trim())) {
      Alert.alert('Validation', 'Username and password are required for this provider type');
      return;
    }

    addProvider.mutate(
      {
        id: `${Date.now()}`,
        name: name.trim(),
        providerType,
        url: url.trim(),
        username: needsCredentials ? username.trim() : null,
        password: needsCredentials ? password.trim() : null,
        epgUrl: epgUrl.trim() || null,
        lastSync: 0,
        isActive: true,
      },
      {
        onSuccess: () => navigation.goBack(),
        onError: err => Alert.alert('Error', String(err)),
      },
    );
  }, [addProvider, name, providerType, url, username, password, epgUrl, needsCredentials, navigation]);

  const inputStyle = [styles.input, { borderColor: theme.colors.border, color: theme.colors.text }];
  const labelStyle = { color: theme.colors.textSecondary };

  return (
    <KeyboardAvoidingView
      style={[styles.root, { backgroundColor: theme.colors.background }]}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <Text style={[styles.label, labelStyle]}>Name</Text>
        <TextInput
          style={inputStyle}
          placeholder="My IPTV"
          placeholderTextColor={theme.colors.textDisabled}
          value={name}
          onChangeText={setName}
        />

        <Text style={[styles.label, labelStyle]}>Provider Type</Text>
        <View style={styles.segmented}>
          {PROVIDER_TYPES.map(pt => (
            <TouchableOpacity
              key={pt.value}
              style={[
                styles.segment,
                {
                  backgroundColor:
                    providerType === pt.value ? theme.colors.primary : theme.colors.surface,
                  borderColor: theme.colors.border,
                },
              ]}
              onPress={() => setProviderType(pt.value)}
            >
              <Text
                style={[
                  styles.segmentText,
                  { color: providerType === pt.value ? '#fff' : theme.colors.text },
                ]}
              >
                {pt.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        <Text style={[styles.label, labelStyle]}>
          {providerType === 'm3u' ? 'M3U URL' : 'Server URL'}
        </Text>
        <TextInput
          style={inputStyle}
          placeholder={providerType === 'm3u' ? 'http://example.com/playlist.m3u' : 'http://example.com:8080'}
          placeholderTextColor={theme.colors.textDisabled}
          value={url}
          onChangeText={setUrl}
          autoCapitalize="none"
          keyboardType="url"
        />

        {needsCredentials ? (
          <>
            <Text style={[styles.label, labelStyle]}>Username</Text>
            <TextInput
              style={inputStyle}
              placeholder="username"
              placeholderTextColor={theme.colors.textDisabled}
              value={username}
              onChangeText={setUsername}
              autoCapitalize="none"
            />
            <Text style={[styles.label, labelStyle]}>Password</Text>
            <TextInput
              style={inputStyle}
              placeholder="password"
              placeholderTextColor={theme.colors.textDisabled}
              value={password}
              onChangeText={setPassword}
              secureTextEntry
            />
          </>
        ) : null}

        {providerType === 'm3u' ? (
          <>
            <Text style={[styles.label, labelStyle]}>EPG URL (optional)</Text>
            <TextInput
              style={inputStyle}
              placeholder="http://example.com/epg.xml"
              placeholderTextColor={theme.colors.textDisabled}
              value={epgUrl}
              onChangeText={setEpgUrl}
              autoCapitalize="none"
              keyboardType="url"
            />
          </>
        ) : null}

        <PrimaryButton
          label="Save Provider"
          onPress={handleSave}
          loading={addProvider.isPending}
          style={styles.saveBtn}
        />
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  scroll: { padding: 16 },
  label: { fontSize: 13, fontWeight: '500', marginTop: 16, marginBottom: 6 },
  input: {
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    fontSize: 15,
  },
  segmented: { flexDirection: 'row', gap: 8, marginBottom: 4 },
  segment: {
    flex: 1,
    paddingVertical: 8,
    borderRadius: 8,
    borderWidth: 1,
    alignItems: 'center',
  },
  segmentText: { fontSize: 13, fontWeight: '500' },
  saveBtn: { marginTop: 32 },
});
