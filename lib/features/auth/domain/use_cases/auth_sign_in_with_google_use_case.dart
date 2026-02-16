import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

@lazySingleton
class AuthSignInWithGoogleUseCase {
  final AuthBehavior _authBehavior;

  AuthSignInWithGoogleUseCase(this._authBehavior);

  Future<Either<Failure, UserEntity>> call() async {
    return _authBehavior.signInWithGoogle();
  }
}
