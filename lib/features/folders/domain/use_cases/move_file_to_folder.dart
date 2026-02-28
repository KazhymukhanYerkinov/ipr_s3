import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/move_file_to_folder_behavior.dart';

class MoveFileToFolderParams {
  final String fileId;
  final String? folderId;

  MoveFileToFolderParams({required this.fileId, this.folderId});
}

@injectable
class MoveFileToFolderUseCase
    implements Callable<MoveFileToFolderParams, void> {
  final MoveFileToFolderBehavior _behavior;

  MoveFileToFolderUseCase(this._behavior);

  @override
  Future<Result<void>> call(MoveFileToFolderParams params) {
    return _behavior.moveFileToFolder(
      fileId: params.fileId,
      folderId: params.folderId,
    );
  }
}
