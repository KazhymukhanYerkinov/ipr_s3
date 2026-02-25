import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class SetPinBehavior {
  Future<Either<Failure, void>> setPin(String pin);
}
