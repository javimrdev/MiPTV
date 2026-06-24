import React from 'react';
import { View, StyleSheet } from 'react-native';
import { useProviders } from '../hooks/useProviders';
import { useAutoSync } from '../hooks/useAutoSync';
import { ThemedText } from '../components/ThemedText';
import { PrimaryButton } from '../components/PrimaryButton';
import { LoadingView } from '../components/LoadingView';
import { SyncBanner } from '../components/SyncBanner';
import { useTheme } from '../theme/useTheme';
import type { TabScreenProps } from '../navigation/types';

export function HomeScreen({ navigation }: TabScreenProps<'HomeTab'>) {
  const theme = useTheme();
  const { data: providers = [], isLoading } = useProviders();

  useAutoSync(providers);

  if (isLoading) {
    return <LoadingView />;
  }

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.background }]}>
      <SyncBanner />
      <View style={styles.body}>
        <ThemedText variant="title" style={styles.title}>MiPTV</ThemedText>
        {providers.length === 0 ? (
          <>
            <ThemedText variant="body" secondary style={styles.msg}>
              Add a provider to start watching
            </ThemedText>
            <PrimaryButton
              label="Add Provider"
              onPress={() => navigation.navigate('ProviderAdd')}
            />
          </>
        ) : (
          <>
            <ThemedText variant="body" secondary style={styles.msg}>
              {providers.length} provider{providers.length > 1 ? 's' : ''} configured
            </ThemedText>
            <PrimaryButton
              label="Manage Providers"
              onPress={() => navigation.navigate('ProviderList')}
            />
          </>
        )}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  body: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 24 },
  title: { marginBottom: 8 },
  msg: { marginBottom: 24, textAlign: 'center' },
});
