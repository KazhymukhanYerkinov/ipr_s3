import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class SignOutBehavior {
  Future<Either<Failure, void>> signOut();
}
