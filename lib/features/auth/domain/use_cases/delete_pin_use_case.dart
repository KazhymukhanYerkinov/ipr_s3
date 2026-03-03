import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/delete_pin_behavior.dart';

@injectable
class DeletePinUseCase implements Callable<NoParams, void> {
  final DeletePinBehavior _behavior;

  DeletePinUseCase(this._behavior);

  @override
  Future<Result<void>> call([_ = const NoParams()]) {
    return _behavior.deletePin();
  }
}
