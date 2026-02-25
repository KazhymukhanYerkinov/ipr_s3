import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

@lazySingleton
class AuthGetCurrentUserUseCase {
  final GetCurrentUserBehavior _behavior;

  AuthGetCurrentUserUseCase(this._behavior);

  Future<Either<Failure, UserEntity?>> call() async {
    return _behavior.getCurrentUser();
  }
}
