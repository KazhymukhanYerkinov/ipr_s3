import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

abstract class GetCurrentUserBehavior {
  Future<Either<Failure, UserEntity?>> getCurrentUser();
}
