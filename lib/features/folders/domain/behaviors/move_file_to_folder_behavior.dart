import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class MoveFileToFolderBehavior {
  Future<Either<Failure, void>> moveFileToFolder({
    required String fileId,
    required String? folderId,
  });
}
