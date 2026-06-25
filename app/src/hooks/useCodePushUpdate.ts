import { useEffect, useRef } from 'react';
import { AppState, type AppStateStatus } from 'react-native';
import codePush, { type DownloadProgress } from 'react-native-code-push';

type UpdateCallbacks = {
  onDownloadProgress?: (progress: DownloadProgress) => void;
};

export function useCodePushUpdate({ onDownloadProgress }: UpdateCallbacks = {}) {
  const onDownloadProgressRef = useRef(onDownloadProgress);
  onDownloadProgressRef.current = onDownloadProgress;

  useEffect(() => {
    function checkForUpdate() {
      codePush
        .sync(
          { installMode: codePush.InstallMode.ON_NEXT_RESTART },
          undefined,
          (progress) => { onDownloadProgressRef.current?.(progress); },
        )
        .catch(() => {});
    }

    function handleAppStateChange(nextState: AppStateStatus) {
      if (nextState === 'active') {
        checkForUpdate();
      }
    }

    const subscription = AppState.addEventListener('change', handleAppStateChange);
    return () => { subscription.remove(); };
  }, []);
}
