import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/verify_pin_behavior.dart';

@injectable
class VerifyPinUseCase implements Callable<String, bool> {
  final VerifyPinBehavior _behavior;

  VerifyPinUseCase(this._behavior);

  @override
  Future<Result<bool>> call(String pin) {
    return _behavior.verifyPin(pin);
  }
}
