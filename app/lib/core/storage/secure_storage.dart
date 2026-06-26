import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> writePassword(String password);
  Future<String?> readPassword();
  Future<void> deletePassword();
}

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _passwordKey = 'xtream_password';

  @override
  Future<void> writePassword(String password) =>
      _storage.write(key: _passwordKey, value: password);

  @override
  Future<String?> readPassword() => _storage.read(key: _passwordKey);

  @override
  Future<void> deletePassword() => _storage.delete(key: _passwordKey);
}
