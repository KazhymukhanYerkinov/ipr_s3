import 'package:ipr_s3/core/result/result.dart';

abstract class AuthenticateWithBiometricsBehavior {
  Future<Result<bool>> authenticateWithBiometrics();
}
