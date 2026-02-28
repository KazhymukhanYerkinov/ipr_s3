import 'package:ipr_s3/core/result/result.dart';

abstract class SignOutBehavior {
  Future<Result<void>> signOut();
}
