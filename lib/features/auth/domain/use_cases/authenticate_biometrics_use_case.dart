import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/authenticate_with_biometrics_behavior.dart';

@lazySingleton
class AuthenticateBiometricsUseCase {
  final AuthenticateWithBiometricsBehavior _behavior;

  AuthenticateBiometricsUseCase(this._behavior);

  Future<Either<Failure, bool>> call() async {
    return _behavior.authenticateWithBiometrics();
  }
}
