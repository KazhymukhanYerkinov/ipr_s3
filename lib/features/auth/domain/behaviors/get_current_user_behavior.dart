import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/auth/domain/models/user.dart';

abstract class GetCurrentUserBehavior {
  Future<Result<UserEntity?>> getCurrentUser();
}
