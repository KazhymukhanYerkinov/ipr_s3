import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/authenticate_with_biometrics_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/has_pin_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/set_pin_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/verify_pin_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

@lazySingleton
class AuthService
    implements
        GetCurrentUserBehavior,
        SignInWithGoogleBehavior,
        SignOutBehavior,
        HasPinBehavior,
        SetPinBehavior,
        VerifyPinBehavior,
        AuthenticateWithBiometricsBehavior {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;
  final PinManager _pinManager;
  final _logger = SecureLogger();

  AuthService(this._authRemoteSource, this._authLocalSource, this._pinManager);

  @override
  Future<Result<UserEntity>> signInWithGoogle() => runGuarded(
    action: () async {
      final user = await _authRemoteSource.signInWithGoogle();
      return user;
    },
    onError: () => const AuthFailure(message: 'Failed to sign in'),
    logger: _logger,
    errorMessage: 'Google sign-in failed',
  );

  @override
  Future<Result<void>> signOut() => runGuarded(
    action: () async {
      await _authRemoteSource.signOut();
    },
    onError: () => const AuthFailure(message: 'Failed to sign out'),
    logger: _logger,
    errorMessage: 'Sign out failed',
  );

  @override
  Future<Result<UserEntity?>> getCurrentUser() => runGuarded(
    action: () async => _authRemoteSource.getCurrentUser(),
    onError: () => const AuthFailure(message: 'Failed to get current user'),
    logger: _logger,
    errorMessage: 'Get current user failed',
  );

  @override
  Future<Result<bool>> hasPin() => runGuarded(
    action: () => _pinManager.hasPin(),
    onError: () => const AuthFailure(message: 'Failed to check PIN'),
    logger: _logger,
    errorMessage: 'Check PIN failed',
  );

  @override
  Future<Result<void>> setPin(String pin) => runGuarded(
    action: () async {
      await _pinManager.setPin(pin);
    },
    onError: () => const AuthFailure(message: 'Failed to set PIN'),
    logger: _logger,
    errorMessage: 'Set PIN failed',
  );

  @override
  Future<Result<bool>> verifyPin(String pin) => runGuarded(
    action: () => _pinManager.verifyPin(pin),
    onError: () => const AuthFailure(message: 'Failed to verify PIN'),
    logger: _logger,
    errorMessage: 'Verify PIN failed',
  );

  @override
  Future<Result<bool>> authenticateWithBiometrics() => runGuarded(
    action: () => _authLocalSource.authenticateWithBiometrics(),
    onError:
        () => const AuthFailure(message: 'Biometric authentication failed'),
    logger: _logger,
    errorMessage: 'Biometric auth failed',
  );
}
