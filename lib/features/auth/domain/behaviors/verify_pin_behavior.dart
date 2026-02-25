import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class VerifyPinBehavior {
  Future<Either<Failure, bool>> verifyPin(String pin);
}
