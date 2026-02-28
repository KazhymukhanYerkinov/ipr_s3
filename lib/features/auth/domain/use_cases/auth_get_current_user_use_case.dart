import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/get_current_user_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

@injectable
class AuthGetCurrentUserUseCase implements Callable<NoParams, UserEntity?> {
  final GetCurrentUserBehavior _behavior;

  AuthGetCurrentUserUseCase(this._behavior);

  @override
  Future<Result<UserEntity?>> call([_ = const NoParams()]) {
    return _behavior.getCurrentUser();
  }
}
