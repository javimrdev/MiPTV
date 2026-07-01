import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/platform/app_platform.dart';
import 'package:miptv/core/responsive/content_width_cap.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/core/widgets/glass/glass_surface.dart';
import 'package:miptv/features/provider/domain/provider_entity.dart';
import 'package:miptv/features/settings/application/locale_controller.dart';
import 'package:miptv/features/settings/application/theme_controller.dart';
import 'package:miptv/l10n/app_localizations.dart';

/// App version string shown in the Information section.
const _kAppVersion = '1.0.0';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final providerAsync = ref.watch(providerProvider);
    final providersAsync = ref.watch(providersListProvider);

    final providerSection = [
      _SectionHeader(l10n.sectionProvider),
      providersAsync.when(
        data: (providers) => providers.isEmpty
            ? const _NoProviderTile()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final provider in providers)
                    _ProviderTile(
                      provider: provider,
                      isActive: provider.id ==
                          providerAsync.maybeWhen(
                            data: (p) => p?.id,
                            orElse: () => null,
                          ),
                    ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: Text(l10n.addSource),
                    onTap: () => context.push('/add-provider'),
                  ),
                ],
              ),
        loading: () => ListTile(
          leading: const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          title: Text(l10n.loading),
        ),
        error: (_, __) => const _NoProviderTile(),
      ),
    ];
    final filtersSection = [
      _SectionHeader(l10n.sectionFilters),
      ListTile(
        leading: const Icon(Icons.filter_alt_outlined),
        title: Text(l10n.customFilters),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/settings/filters'),
      ),
    ];
    final appearanceSection = [
      _SectionHeader(l10n.sectionAppearance),
      const _ThemeModeTile(),
      const _LanguageTile(),
    ];
    final infoSection = [
      _SectionHeader(l10n.sectionInfo),
      ListTile(
        leading: const Icon(Icons.info_outline),
        title: const Text('MiPTV'),
        subtitle: Text(l10n.appVersion(_kAppVersion)),
      ),
    ];

    return AppScaffold(
      title: Text(l10n.settingsTitle),
      extendBehindNavBar: true,
      // Android: same flat ListView + Divider list as before this change.
      // iOS: each section becomes its own frosted-glass card instead.
      body: ContentWidthCap(
        maxWidth: 720,
        child: !isIOSGlass
            ? ListView(
                children: [
                  ...providerSection,
                  const Divider(),
                  ...filtersSection,
                  const Divider(),
                  ...appearanceSection,
                  const Divider(),
                  ...infoSection,
                ],
              )
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _GlassSection(children: providerSection),
                  _GlassSection(children: filtersSection),
                  _GlassSection(children: appearanceSection),
                  _GlassSection(children: infoSection),
                ],
              ),
      ),
    );
  }
}

/// iOS-only: groups a settings section's [_SectionHeader] + tiles inside a
/// [GlassSurface] card. Each card is short and finite (a handful of static
/// tiles), so a real `BackdropFilter` per section is cheap — unlike the long
/// virtualized channel/movie lists, which intentionally avoid it.
class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GlassSurface(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _NoProviderTile extends StatelessWidget {
  const _NoProviderTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(AppLocalizations.of(context).addProvider),
      onTap: () => context.push('/add-provider'),
    );
  }
}

class _ProviderTile extends ConsumerWidget {
  const _ProviderTile({required this.provider, required this.isActive});

  final ProviderEntity provider;
  final bool isActive;

  Future<void> _activate(WidgetRef ref) => switchToProvider(ref, provider.id);

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(providerRepositoryProvider).syncCategories();
      ref.invalidate(categoriesProvider);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.syncCategoriesSuccess)),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.syncCategoriesError)));
    }
  }

  Future<void> _remove(WidgetRef ref) async {
    final wasActive = isActive;
    await ref.read(providerRepositoryProvider).removeProvider(provider.id);
    ref.invalidate(providerProvider);
    ref.invalidate(providersListProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(favoritesViewProvider);
    ref.invalidate(vodCategoriesProvider);
    if (!wasActive) return;
    // Removing the active source reset the caches and picked another one (if
    // any) as active: sync it now so Home doesn't sit on an empty category
    // list until the user finds the manual Sync button.
    final newActive = await ref.read(providerRepositoryProvider).getProvider();
    if (newActive != null) {
      await ref.read(providerRepositoryProvider).syncCategories();
      ref.invalidate(categoriesProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(
            isActive ? Icons.radio_button_checked : Icons.dns_outlined,
          ),
          title: Text(provider.name),
          subtitle: Text('${provider.server} · ${provider.username}'),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.end,
          children: [
            if (!isActive)
              TextButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l10n.activate),
                onPressed: () => _activate(ref),
              ),
            TextButton.icon(
              icon: const Icon(Icons.sync),
              label: Text(l10n.sync),
              onPressed: () => _sync(context, ref),
            ),
            TextButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.remove),
              onPressed: () => _remove(ref),
            ),
          ],
        ),
      ],
    );
  }
}

/// Theme selector: lets the user choose System / Light / Dark, persisted via
/// [themeControllerProvider].
class _ThemeModeTile extends ConsumerWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeControllerProvider);
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(l10n.theme),
      subtitle: SegmentedButton<ThemeMode>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
          ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
          ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
        ],
        selected: {mode},
        onSelectionChanged: (selected) => ref
            .read(themeControllerProvider.notifier)
            .setThemeMode(selected.first),
      ),
    );
  }
}

/// One selectable language option: `null` locale means "follow the system".
class _LanguageOption {
  const _LanguageOption(this.locale, this.endonym);

  /// The locale to apply, or `null` for the system default.
  final Locale? locale;

  /// Name of the language written in that same language (or, for the system
  /// option, a localized "system default" label resolved at display time).
  final String endonym;
}

/// Supported languages shown in the picker, each labeled in its own language.
/// The leading `null` entry (system default) gets its label localized in the UI.
const _kLanguageOptions = <_LanguageOption>[
  _LanguageOption(null, ''),
  _LanguageOption(Locale('en'), 'English'),
  _LanguageOption(Locale('es'), 'Español'),
  _LanguageOption(Locale('fr'), 'Français'),
  _LanguageOption(Locale('de'), 'Deutsch'),
  _LanguageOption(Locale('pt'), 'Português'),
  _LanguageOption(Locale('it'), 'Italiano'),
];

/// Functional language selector. Defaults to the system locale and lets the
/// user override it; the choice is persisted via [localeControllerProvider].
class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  String _labelFor(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.languageSystem;
    return _kLanguageOptions
        .firstWhere(
          (o) => o.locale?.languageCode == locale.languageCode,
          orElse: () => const _LanguageOption(null, ''),
        )
        .endonym;
  }

  Future<void> _pickLanguage(
    BuildContext context,
    WidgetRef ref,
    Locale? current,
  ) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<_LanguageOption>(
      context: context,
      showDragHandle: true,
      backgroundColor: isIOSGlass ? Colors.transparent : null,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (sheetContext) {
        final content = SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final option in _kLanguageOptions)
                ListTile(
                  leading: Icon(
                    option.locale?.languageCode == current?.languageCode
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(
                    option.locale == null
                        ? l10n.languageSystem
                        : option.endonym,
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(option),
                ),
            ],
          ),
        );
        if (!isIOSGlass) return content;
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: GlassSurface(
            borderRadius: BorderRadius.circular(20),
            child: content,
          ),
        );
      },
    );
    if (selected != null) {
      await ref
          .read(localeControllerProvider.notifier)
          .setLocale(selected.locale);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      subtitle: Text(_labelFor(locale, l10n)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pickLanguage(context, ref, locale),
    );
  }
}
