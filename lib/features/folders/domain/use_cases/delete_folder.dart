import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart';

@injectable
class DeleteFolderUseCase {
  final DeleteFolderBehavior _behavior;

  DeleteFolderUseCase(this._behavior);

  Future<Either<Failure, void>> call(String folderId) {
    return _behavior.deleteFolder(folderId);
  }
}
