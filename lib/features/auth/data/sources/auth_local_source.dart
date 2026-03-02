import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

abstract class AuthLocalSource {
  Future<bool> authenticateWithBiometrics();
}

@LazySingleton(as: AuthLocalSource)
class AuthLocalSourceImpl implements AuthLocalSource {
  final LocalAuthentication _localAuth;

  AuthLocalSourceImpl(this._localAuth);

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
