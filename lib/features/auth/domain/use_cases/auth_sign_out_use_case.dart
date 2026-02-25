import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart';

@lazySingleton
class AuthSignOutUseCase {
  final SignOutBehavior _behavior;

  AuthSignOutUseCase(this._behavior);

  Future<Either<Failure, void>> call() async {
    return _behavior.signOut();
  }
}
