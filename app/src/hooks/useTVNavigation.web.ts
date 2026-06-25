import { useEffect, useRef } from 'react';

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

const KEY_MAP: Record<string, TVAction> = {
  ArrowUp: 'up',
  ArrowDown: 'down',
  ArrowLeft: 'left',
  ArrowRight: 'right',
  Enter: 'select',
  ' ': 'playPause',
  Escape: 'menu',
  Backspace: 'menu',
};

export function useTVNavigation(handlers: TVNavigationHandlers): void {
  const handlersRef = useRef<TVNavigationHandlers>(handlers);
  handlersRef.current = handlers;

  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      const action = KEY_MAP[e.key];
      if (!action) { return; }
      const handler = handlersRef.current[action];
      if (handler) {
        e.preventDefault();
        handler();
      }
    };
    window.addEventListener('keydown', onKeyDown);
    return () => window.removeEventListener('keydown', onKeyDown);
  }, []);
}
