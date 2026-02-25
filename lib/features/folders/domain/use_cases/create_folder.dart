import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';

@injectable
class CreateFolderUseCase {
  final FoldersBehavior _repository;

  CreateFolderUseCase(this._repository);

  Future<Either<Failure, FolderItem>> call({
    required String name,
    String? parentId,
  }) {
    return _repository.createFolder(name: name, parentId: parentId);
  }
}
