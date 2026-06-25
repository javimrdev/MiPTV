import React from 'react';
import TestRenderer, { act } from 'react-test-renderer';
import { useAutoSync } from '../useAutoSync';
import type { Provider } from '../../specs/NativeMiPTVCore';

const mockSyncProvider = jest.fn();

// useMiPTVCore returns a fresh object each call on purpose here, to prove the
// effect's `syncedRef` guard holds even when `core` identity churns.
jest.mock('../useMiPTVCore', () => ({
  useMiPTVCore: () => ({ syncProvider: mockSyncProvider }),
}));

jest.mock('@tanstack/react-query', () => ({
  useQueryClient: () => ({ invalidateQueries: jest.fn() }),
}));

function Harness({ providers }: { providers: Provider[] }) {
  useAutoSync(providers);
  return null;
}

const flush = () => new Promise<void>(resolve => setTimeout(() => resolve(), 0));

const makeProvider = (id: string): Provider =>
  ({ id, isActive: true, lastSync: 0 } as unknown as Provider);

describe('useAutoSync', () => {
  beforeEach(() => {
    mockSyncProvider.mockReset();
  });

  it('calls mockSyncProvider exactly once and does NOT retry in a loop when sync fails', async () => {
    mockSyncProvider.mockRejectedValue(new Error('network down'));

    await act(async () => {
      TestRenderer.create(<Harness providers={[makeProvider('p1')]} />);
      // Allow the rejected promise + failSync store update + re-renders to settle.
      await flush();
      await flush();
      await flush();
    });

    expect(mockSyncProvider).toHaveBeenCalledTimes(1);
  });

  it('calls mockSyncProvider exactly once on success', async () => {
    mockSyncProvider.mockResolvedValue(42);

    await act(async () => {
      TestRenderer.create(<Harness providers={[makeProvider('p2')]} />);
      await flush();
      await flush();
    });

    expect(mockSyncProvider).toHaveBeenCalledTimes(1);
  });
});
