import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

@LazySingleton(as: AuthBehavior)
class AuthService implements AuthBehavior {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;

  /// SecureLogger — безопасный логгер, который маскирует чувствительные данные.
  /// Используем его вместо print(), чтобы токены и email не попали в logcat.
  final _logger = SecureLogger();

  AuthService(this._authRemoteSource, this._authLocalSource);

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _authRemoteSource.signInWithGoogle();
      _logger.info('User signed in successfully');
      return Right(user);
    } catch (e, stackTrace) {
      // Логируем ошибку через SecureLogger — он замаскирует токены/email.
      // В UI отдаём только общее сообщение без e.toString(),
      // потому что e.toString() может содержать accessToken/idToken от Google.
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
}
