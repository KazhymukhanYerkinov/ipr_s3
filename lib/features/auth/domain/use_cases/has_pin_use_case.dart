import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/has_pin_behavior.dart';

@injectable
class HasPinUseCase implements Callable<NoParams, bool> {
  final HasPinBehavior _behavior;

  HasPinUseCase(this._behavior);

  @override
  Future<Result<bool>> call([_ = const NoParams()]) {
    return _behavior.hasPin();
  }
}
