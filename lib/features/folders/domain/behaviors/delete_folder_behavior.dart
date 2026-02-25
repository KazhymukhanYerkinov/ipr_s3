import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class DeleteFolderBehavior {
  Future<Either<Failure, void>> deleteFolder(String folderId);
}
