import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          const _SectionHeader('Proveedor'),
          providerAsync.when(
            data: (provider) => provider == null
                ? const _NoProviderTile()
                : _ProviderTile(server: provider.server, username: provider.username),
            loading: () => const ListTile(
              leading: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              title: Text('Cargando…'),
            ),
            error: (_, __) => const _NoProviderTile(),
          ),
          const Divider(),
          const _SectionHeader('Apariencia'),
          const _ThemeModeTile(),
          const _LanguageTile(),
          const Divider(),
          const _SectionHeader('Información'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('MiPTV'),
            subtitle: Text('Versión 1.0.0 — MVP v0.1'),
          ),
        ],
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
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
      title: const Text('Añadir proveedor'),
      onTap: () => context.push('/add-provider'),
    );
  }
}

class _ProviderTile extends ConsumerWidget {
  const _ProviderTile({required this.server, required this.username});

  final String server;
  final String username;

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(providerRepositoryProvider).syncCategories();
      ref.invalidate(categoriesProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('Categorías sincronizadas')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo sincronizar')),
      );
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    await ref.read(providerRepositoryProvider).removeProvider();
    ref.invalidate(providerProvider);
    ref.invalidate(categoriesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.dns_outlined),
          title: Text(server),
          subtitle: Text(username),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Sincronizar'),
              onPressed: () => _sync(context, ref),
            ),
            TextButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
              onPressed: () => _remove(context, ref),
            ),
          ],
        ),
      ],
    );
  }
}

/// Theme selector — visual placeholder, not wired yet (per MVP scope).
class _ThemeModeTile extends StatelessWidget {
  const _ThemeModeTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: const Text('Tema'),
      subtitle: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
          ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
          ButtonSegment(value: ThemeMode.dark, label: Text('Oscuro')),
        ],
        selected: const {ThemeMode.dark},
        // Inert for now: theming is out of scope for this MVP step.
        onSelectionChanged: null,
      ),
    );
  }
}

/// Language selector — visual placeholder, not wired yet (per MVP scope).
class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      enabled: false,
      leading: Icon(Icons.language),
      title: Text('Idioma'),
      subtitle: Text('Español'),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
