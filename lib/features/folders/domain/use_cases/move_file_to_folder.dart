import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/folders_behavior.dart';

@injectable
class MoveFileToFolderUseCase {
  final FoldersBehavior _repository;

  MoveFileToFolderUseCase(this._repository);

  /// [folderId] = null означает перемещение в корень (без папки).
  Future<Either<Failure, void>> call({
    required String fileId,
    required String? folderId,
  }) {
    return _repository.moveFileToFolder(fileId: fileId, folderId: folderId);
  }
}
