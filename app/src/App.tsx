import './i18n';
import React, { useEffect } from 'react';
import NativeMiPTVCore from './specs/NativeMiPTVCore';
import { StyleSheet } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import codePush from 'react-native-code-push';
import { RootNavigator } from './navigation/RootNavigator';
import { useCodePushUpdate } from './hooks/useCodePushUpdate';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: { retry: 2, staleTime: 30_000 },
  },
});

function AppRoot() {
  useCodePushUpdate();

  useEffect(() => {
    NativeMiPTVCore.initialize('miptv.db')
      .then(() => console.log('[MiPTVCore] DB init OK'))
      .catch((e: unknown) => console.error('[MiPTVCore] DB init FAILED:', e));
  }, []);

  return (
    <GestureHandlerRootView style={styles.root}>
      <SafeAreaProvider>
        <QueryClientProvider client={queryClient}>
          <NavigationContainer>
            <RootNavigator />
          </NavigationContainer>
        </QueryClientProvider>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
});

export default codePush({ checkFrequency: codePush.CheckFrequency.MANUAL })(AppRoot);
