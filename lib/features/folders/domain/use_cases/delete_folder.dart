import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/folders_behavior.dart';

@injectable
class DeleteFolderUseCase {
  final FoldersBehavior _repository;

  DeleteFolderUseCase(this._repository);

  Future<Either<Failure, void>> call(String folderId) {
    return _repository.deleteFolder(folderId);
  }
}
