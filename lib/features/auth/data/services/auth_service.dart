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
  Future<Result<UserEntity>> signInWithGoogle() async {
    try {
      final user = await _authRemoteSource.signInWithGoogle();
      _logger.info('User signed in successfully');
      return SuccessResult(user);
    } catch (e, stackTrace) {
      _logger.error('Google sign-in failed', e, stackTrace);
      return ErrorResult(const AuthFailure(message: 'Failed to sign in'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _authRemoteSource.signOut();
      await _authLocalSource.deleteToken();
      _logger.info('User signed out successfully');
      return SuccessResult(null);
    } catch (e, stackTrace) {
      _logger.error('Sign out failed', e, stackTrace);
      return ErrorResult(const AuthFailure(message: 'Failed to sign out'));
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      final user = _authRemoteSource.getCurrentUser();
      return SuccessResult(user);
    } catch (e, stackTrace) {
      _logger.error('Get current user failed', e, stackTrace);
      return ErrorResult(
        const AuthFailure(message: 'Failed to get current user'),
      );
    }
  }

  @override
  Future<Result<bool>> hasPin() async {
    try {
      final result = await _pinManager.hasPin();
      return SuccessResult(result);
    } catch (e, stackTrace) {
      _logger.error('Check PIN failed', e, stackTrace);
      return ErrorResult(const AuthFailure(message: 'Failed to check PIN'));
    }
  }

  @override
  Future<Result<void>> setPin(String pin) async {
    try {
      await _pinManager.setPin(pin);
      _logger.info('PIN set successfully');
      return SuccessResult(null);
    } catch (e, stackTrace) {
      _logger.error('Set PIN failed', e, stackTrace);
      return ErrorResult(const AuthFailure(message: 'Failed to set PIN'));
    }
  }

  @override
  Future<Result<bool>> verifyPin(String pin) async {
    try {
      final result = await _pinManager.verifyPin(pin);
      return SuccessResult(result);
    } catch (e, stackTrace) {
      _logger.error('Verify PIN failed', e, stackTrace);
      return ErrorResult(const AuthFailure(message: 'Failed to verify PIN'));
    }
  }

  @override
  Future<Result<bool>> authenticateWithBiometrics() async {
    try {
      final result = await _authLocalSource.authenticateWithBiometrics();
      return SuccessResult(result);
    } catch (e, stackTrace) {
      _logger.error('Biometric auth failed', e, stackTrace);
      return ErrorResult(
        const AuthFailure(message: 'Biometric authentication failed'),
      );
    }
  }
}
