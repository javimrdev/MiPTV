import { useRef } from 'react';
import { useTVEventHandler, Platform } from 'react-native';
import type { HWEvent } from 'react-native';

type TVAction =
  | 'up'
  | 'down'
  | 'left'
  | 'right'
  | 'select'
  | 'menu'
  | 'playPause'
  | 'longUp'
  | 'longDown'
  | 'longLeft'
  | 'longRight';

export type TVNavigationHandlers = Partial<Record<TVAction, () => void>>;

export function useTVNavigation(handlers: TVNavigationHandlers): void {
  const handlersRef = useRef<TVNavigationHandlers>(handlers);
  handlersRef.current = handlers;

  useTVEventHandler((event: HWEvent) => {
    if (!Platform.isTV) { return; }
    const handler = handlersRef.current[event.eventType as TVAction];
    if (handler) { handler(); }
  });
}
