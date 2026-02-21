import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';

abstract class AuthBehavior {
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, bool>> hasPin();
  Future<Either<Failure, void>> setPin(String pin);
  Future<Either<Failure, bool>> verifyPin(String pin);
  Future<Either<Failure, bool>> authenticateWithBiometrics();
}
