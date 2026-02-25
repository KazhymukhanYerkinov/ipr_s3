import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

abstract class SignInWithGoogleBehavior {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
}
