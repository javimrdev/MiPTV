import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';

class AddProviderScreen extends ConsumerStatefulWidget {
  const AddProviderScreen({super.key});

  @override
  ConsumerState<AddProviderScreen> createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends ConsumerState<AddProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _serverCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(providerRepositoryProvider);
      await repo.addProvider(
        server: _serverCtrl.text.trim(),
        username: _userCtrl.text.trim(),
        password: _passCtrl.text,
      );
      await repo.syncCategories();
      if (mounted) context.go('/home');
    } on AppError catch (e) {
      setState(() => _errorMessage = e.userMessage);
    } catch (_) {
      setState(() => _errorMessage = 'Error inesperado. Inténtalo de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir proveedor')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _serverCtrl,
                decoration: const InputDecoration(labelText: 'URL del servidor'),
                keyboardType: TextInputType.url,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Introduce la URL del servidor' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userCtrl,
                decoration: const InputDecoration(labelText: 'Usuario'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Introduce el usuario' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Introduce la contraseña' : null,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Conectar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
