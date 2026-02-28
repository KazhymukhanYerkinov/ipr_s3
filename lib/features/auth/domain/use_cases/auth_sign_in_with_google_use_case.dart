import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/auth/domain/behaviors/sign_in_with_google_behavior.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

@injectable
class AuthSignInWithGoogleUseCase implements Callable<NoParams, UserEntity> {
  final SignInWithGoogleBehavior _behavior;

  AuthSignInWithGoogleUseCase(this._behavior);

  @override
  Future<Result<UserEntity>> call([_ = const NoParams()]) {
    return _behavior.signInWithGoogle();
  }
}
