import 'package:ipr_s3/core/result/result.dart';

abstract class HasPinBehavior {
  Future<Result<bool>> hasPin();
}
