import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class DeleteFileBehavior {
  Future<Either<Failure, void>> deleteFile(String fileId);
}
