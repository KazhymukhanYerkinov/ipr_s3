import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_local_source.dart';
import 'package:ipr_s3/features/auth/data/sources/auth_remote_source.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

@LazySingleton(as: AuthBehavior)
class AuthService implements AuthBehavior {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;

  AuthService(this._authRemoteSource, this._authLocalSource);

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _authRemoteSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteSource.signOut();
      await _authLocalSource.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign out'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _authRemoteSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to get current user'));
    }
  }
}
