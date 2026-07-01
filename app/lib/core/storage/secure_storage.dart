import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> writePassword(int providerId, String password);
  Future<String?> readPassword(int providerId);
  Future<void> deletePassword(int providerId);
}

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static String _passwordKey(int providerId) => 'xtream_password_$providerId';

  @override
  Future<void> writePassword(int providerId, String password) =>
      _storage.write(key: _passwordKey(providerId), value: password);

  @override
  Future<String?> readPassword(int providerId) =>
      _storage.read(key: _passwordKey(providerId));

  @override
  Future<void> deletePassword(int providerId) =>
      _storage.delete(key: _passwordKey(providerId));
}
