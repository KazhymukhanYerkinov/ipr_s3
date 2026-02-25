import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class HasPinBehavior {
  Future<Either<Failure, bool>> hasPin();
}
