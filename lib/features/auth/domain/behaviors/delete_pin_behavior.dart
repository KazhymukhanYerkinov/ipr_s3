import 'package:ipr_s3/core/result/result.dart';

abstract class DeletePinBehavior {
  Future<Result<void>> deletePin();
}
