import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/set_pin_behavior.dart';

@injectable
class SetPinUseCase implements Callable<String, void> {
  final SetPinBehavior _behavior;

  SetPinUseCase(this._behavior);

  @override
  Future<Result<void>> call(String pin) {
    return _behavior.setPin(pin);
  }
}
