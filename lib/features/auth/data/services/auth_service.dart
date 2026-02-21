import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/pin_manager.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

@LazySingleton(as: AuthBehavior)
class AuthService implements AuthBehavior {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;
  final PinManager _pinManager;
  final _logger = SecureLogger();

  AuthService(this._authRemoteSource, this._authLocalSource, this._pinManager);

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _authRemoteSource.signInWithGoogle();
      _logger.info('User signed in successfully');
      return Right(user);
    } catch (e, stackTrace) {
      _logger.error('Google sign-in failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to sign in'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteSource.signOut();
      await _authLocalSource.deleteToken();
      _logger.info('User signed out successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Sign out failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to sign out'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _authRemoteSource.getCurrentUser();
      return Right(user);
    } catch (e, stackTrace) {
      _logger.error('Get current user failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to get current user'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasPin() async {
    try {
      final result = await _pinManager.hasPin();
      return Right(result);
    } catch (e, stackTrace) {
      _logger.error('Check PIN failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to check PIN'));
    }
  }

  @override
  Future<Either<Failure, void>> setPin(String pin) async {
    try {
      await _pinManager.setPin(pin);
      _logger.info('PIN set successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Set PIN failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to set PIN'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) async {
    try {
      final result = await _pinManager.verifyPin(pin);
      return Right(result);
    } catch (e, stackTrace) {
      _logger.error('Verify PIN failed', e, stackTrace);
      return Left(AuthFailure(message: 'Failed to verify PIN'));
    }
  }

  @override
  Future<Either<Failure, bool>> authenticateWithBiometrics() async {
    try {
      final result = await _authLocalSource.authenticateWithBiometrics();
      return Right(result);
    } catch (e, stackTrace) {
      _logger.error('Biometric auth failed', e, stackTrace);
      return Left(AuthFailure(message: 'Biometric authentication failed'));
    }
  }
}
