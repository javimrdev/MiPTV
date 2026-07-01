import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/widgets/filter_pill.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/home/domain/home_filters.dart';
import 'package:miptv/features/home/presentation/home_filter_labels.dart';
import 'package:miptv/features/home/presentation/home_filters_provider.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Horizontal bar of filter pills (Quality / Category / Country) shown at the
/// top of the Home screen, plus a destructive reset pill when any filter is set.
class HomeFiltersBar extends ConsumerWidget {
  const HomeFiltersBar({super.key});

  Future<void> _openOptions(
    BuildContext context,
    WidgetRef ref,
    HomeFilterType type,
    String? current,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (_) => _FilterOptionsSheet(type: type, current: current),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final filters = ref.watch(homeFiltersProvider);
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          if (filters.hasAny) ...[
            _buildClearChip(context, ref, scheme, l10n),
            const SizedBox(width: 8),
          ],
          for (final type in HomeFilterType.values) ...[
            FilterPill(
              label: type.label(l10n),
              value: filters.valueOf(type),
              onTap: () =>
                  _openOptions(context, ref, type, filters.valueOf(type)),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildClearChip(
    BuildContext context,
    WidgetRef ref,
    ColorScheme scheme,
    AppLocalizations l10n,
  ) {
    // On iOS the chip sits on the neutral glass tint (not a red background),
    // so the icon/label must carry the red themselves via `error` — `onError`
    // (designed for content atop a red background) would be low-contrast and
    // not read as red here.
    final contentColor = isIOSGlass ? scheme.error : scheme.onError;
    final chip = ActionChip(
      avatar: Icon(Icons.delete, size: 18, color: contentColor),
      label: Text(
        l10n.filtersClear,
        style: TextStyle(color: contentColor),
      ),
      backgroundColor: isIOSGlass ? Colors.transparent : scheme.error,
      side: isIOSGlass ? BorderSide.none : null,
      onPressed: () => ref.read(homeFiltersProvider.notifier).reset(),
    );

    if (!isIOSGlass) return chip;

    return GlassSurface(borderRadius: BorderRadius.circular(20), child: chip);
  }
}

class _FilterOptionsSheet extends ConsumerWidget {
  const _FilterOptionsSheet({required this.type, required this.current});

  final HomeFilterType type;
  final String? current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(filterOptionsProvider(type));

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: optionsAsync.when(
          data: (options) => ListView(
            shrinkWrap: true,
            children: [
              for (final option in options)
                ListTile(
                  leading: Icon(
                    option == current
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(option),
                  onTap: () {
                    final notifier = ref.read(homeFiltersProvider.notifier);
                    // Re-tapping the active option clears the filter.
                    notifier.setValue(type, option == current ? null : option);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(AppLocalizations.of(context).filterOptionsLoadError),
            ),
          ),
        ),
      ),
    );
  }
}
