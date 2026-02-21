import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

abstract class AuthLocalSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> deleteToken();
  Future<bool> authenticateWithBiometrics();
}

@LazySingleton(as: AuthLocalSource)
class AuthLocalSourceImpl implements AuthLocalSource {
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  AuthLocalSourceImpl(this._secureStorage, this._localAuth);

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

  /// Биометрическая аутентификация через Face ID / Touch ID / Fingerprint.
  /// Возвращает false если устройство не поддерживает биометрию или
  /// пользователь отменил — graceful degradation, приложение не падает.
  @override
  Future<bool> authenticateWithBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isSupported = await _localAuth.isDeviceSupported();

    if (!canCheck || !isSupported) return false;

    return _localAuth.authenticate(
      localizedReason: 'Confirm to unlock File Secure',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  }
}
