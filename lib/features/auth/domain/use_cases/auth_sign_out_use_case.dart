import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/auth_behavior.dart';

@lazySingleton
class AuthSignOutUseCase {
  final AuthBehavior _authBehavior;

  AuthSignOutUseCase(this._authBehavior);

  Future<Either<Failure, void>> call() async {
    return _authBehavior.signOut();
  }
}
