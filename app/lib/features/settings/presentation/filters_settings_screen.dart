import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/features/home/domain/home_filters.dart';
import 'package:miptv/features/home/presentation/home_filter_labels.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// Manage manually-added filter values per dimension. Added values persist
/// (Isar) and show up alongside the predefined options in the Home pills.
class FiltersSettingsScreen extends StatelessWidget {
  const FiltersSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context).customFilters),
      body: ListView(
        children: const [
          _FilterSection(type: HomeFilterType.quality),
          Divider(),
          _FilterSection(type: HomeFilterType.codec),
          Divider(),
          _FilterSection(type: HomeFilterType.category),
          Divider(),
          _FilterSection(type: HomeFilterType.country),
        ],
      ),
    );
  }
}

class _FilterSection extends ConsumerStatefulWidget {
  const _FilterSection({required this.type});

  final HomeFilterType type;

  @override
  ConsumerState<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends ConsumerState<_FilterSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    await ref.read(customFilterRepositoryProvider).add(widget.type, value);
    _controller.clear();
    ref.invalidate(customFilterValuesProvider(widget.type));
    ref.invalidate(filterOptionsProvider(widget.type));
  }

  Future<void> _remove(String value) async {
    await ref.read(customFilterRepositoryProvider).remove(widget.type, value);
    ref.invalidate(customFilterValuesProvider(widget.type));
    ref.invalidate(filterOptionsProvider(widget.type));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final valuesAsync = ref.watch(customFilterValuesProvider(widget.type));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            widget.type.label(l10n),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.addFilterHint,
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _add, child: Text(l10n.add)),
            ],
          ),
        ),
        valuesAsync.when(
          data: (values) => values.isEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(l10n.noCustomFilters),
                )
              : Column(
                  children: [
                    for (final value in values)
                      ListTile(
                        dense: true,
                        title: Text(value),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: l10n.delete,
                          onPressed: () => _remove(value),
                        ),
                      ),
                  ],
                ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.filtersLoadError),
          ),
        ),
      ],
    );
  }
}
