import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_out_behavior.dart';

@injectable
class AuthSignOutUseCase implements Callable<NoParams, void> {
  final SignOutBehavior _behavior;

  AuthSignOutUseCase(this._behavior);

  @override
  Future<Result<void>> call([_ = const NoParams()]) {
    return _behavior.signOut();
  }
}
