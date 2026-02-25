import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';

abstract class FoldersBehavior {
  Future<Either<Failure, List<FolderItem>>> getFolders();
  Future<Either<Failure, FolderItem>> createFolder({
    required String name,
    String? parentId,
  });
  Future<Either<Failure, void>> deleteFolder(String folderId);
  Future<Either<Failure, void>> moveFileToFolder({
    required String fileId,
    required String? folderId,
  });
}
