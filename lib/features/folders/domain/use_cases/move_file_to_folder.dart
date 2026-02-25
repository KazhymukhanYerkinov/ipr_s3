import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/move_file_to_folder_behavior.dart';

@injectable
class MoveFileToFolderUseCase {
  final MoveFileToFolderBehavior _behavior;

  MoveFileToFolderUseCase(this._behavior);

  /// [folderId] = null означает перемещение в корень (без папки).
  Future<Either<Failure, void>> call({
    required String fileId,
    required String? folderId,
  }) {
    return _behavior.moveFileToFolder(fileId: fileId, folderId: folderId);
  }
}
