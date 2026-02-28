import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart';

@injectable
class DeleteFolderUseCase implements Callable<String, void> {
  final DeleteFolderBehavior _behavior;

  DeleteFolderUseCase(this._behavior);

  @override
  Future<Result<void>> call(String folderId) {
    return _behavior.deleteFolder(folderId);
  }
}
