import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

@lazySingleton
class AuthSignInWithGoogleUseCase {
  final SignInWithGoogleBehavior _behavior;

  AuthSignInWithGoogleUseCase(this._behavior);

  Future<Either<Failure, UserEntity>> call() async {
    return _behavior.signInWithGoogle();
  }
}
