import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> deleteToken();
}

@LazySingleton(as: AuthLocalSource)
class AuthLocalSourceImpl implements AuthLocalSource {
  final FlutterSecureStorage _secureStorage;

  AuthLocalSourceImpl(this._secureStorage);

  static const _tokenKey = 'firebase_id_token';

  @override
  Future<void> cacheToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getCachedToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
