import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

abstract class CreateFolderBehavior {
  Future<Either<Failure, FolderItem>> createFolder({
    required String name,
    String? parentId,
  });
}
