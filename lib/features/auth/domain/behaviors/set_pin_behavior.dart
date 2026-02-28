import 'package:ipr_s3/core/result/result.dart';

abstract class SetPinBehavior {
  Future<Result<void>> setPin(String pin);
}
