import 'package:ipr_s3/core/result/result.dart';

abstract class VerifyPinBehavior {
  Future<Result<bool>> verifyPin(String pin);
}
