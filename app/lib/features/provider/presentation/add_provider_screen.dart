import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:miptv/app/providers.dart';
import 'package:miptv/core/errors/app_error.dart';
import 'package:miptv/core/responsive/content_width_cap.dart';
import 'package:miptv/core/widgets/adaptive_scaffold.dart';
import 'package:miptv/l10n/app_localizations.dart';

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
  bool _diagLoading = false;
  String? _diagResult;

  @override
  void dispose() {
    _serverCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _testNative() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _diagLoading = true;
      _diagResult = null;
    });
    try {
      final api = ref.read(xtreamApiProvider);
      final result = await api.testConnectionNative(
        server: _serverCtrl.text.trim(),
        username: _userCtrl.text.trim(),
        password: _passCtrl.text,
      );
      if (mounted) setState(() => _diagResult = result);
    } finally {
      if (mounted) setState(() => _diagLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    // Captured before any await to localize error messages without a gap.
    final l10n = AppLocalizations.of(context);
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
      TextInput.finishAutofillContext();
      // Refresh shared state so Home/Settings reflect the new provider.
      ref.invalidate(providerProvider);
      ref.invalidate(categoriesProvider);
      if (mounted) context.go('/home');
    } on AppError catch (e) {
      setState(() => _errorMessage = e.userMessage(l10n));
    } catch (_) {
      setState(() => _errorMessage = l10n.errorUnexpected);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      title: Text(l10n.addProvider),
      body: ContentWidthCap(
        maxWidth: 480,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _serverCtrl,
                    decoration: InputDecoration(labelText: l10n.serverUrlLabel),
                    keyboardType: TextInputType.url,
                    autofillHints: const [AutofillHints.url],
                    validator: (v) => v == null || v.isEmpty
                        ? l10n.serverUrlValidation
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _userCtrl,
                    decoration: InputDecoration(labelText: l10n.usernameLabel),
                    autofillHints: const [AutofillHints.username],
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.usernameValidation : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: InputDecoration(labelText: l10n.passwordLabel),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    validator: (v) =>
                        v == null || v.isEmpty ? l10n.passwordValidation : null,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  OutlinedButton(
                    onPressed: (_loading || _diagLoading) ? null : _testNative,
                    child: _diagLoading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.nativeDiagnostic),
                  ),
                  if (_diagResult != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _diagResult!,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.connect),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
