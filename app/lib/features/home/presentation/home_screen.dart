import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/features/categories/domain/category_entity.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MiPTV')),
      body: providerAsync.when(
        data: (provider) =>
            provider == null ? const _NoProviderView() : const _CategoriesList(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _NoProviderView(),
      ),
    );
  }
}

class _NoProviderView extends StatelessWidget {
  const _NoProviderView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.live_tv, size: 56),
            const SizedBox(height: 16),
            const Text(
              'Aún no has añadido ningún proveedor IPTV.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Añadir proveedor'),
              onPressed: () => context.push('/add-provider'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesList extends ConsumerWidget {
  const _CategoriesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (cats) => ListView.builder(
        itemCount: cats.length,
        itemBuilder: (_, i) => _CategoryTile(category: cats[i]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.signal_wifi_off, size: 48),
              const SizedBox(height: 12),
              Text(
                e is AppError
                    ? e.userMessage
                    : 'Error inesperado. Inténtalo de nuevo.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(categoriesProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category),
      title: Text(category.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/category/${category.id}'),
    );
  }
}
