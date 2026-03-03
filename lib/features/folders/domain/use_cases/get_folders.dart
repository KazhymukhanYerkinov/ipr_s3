import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

@injectable
class GetFoldersUseCase implements Callable<NoParams, List<FolderItem>> {
  final GetFoldersBehavior _behavior;

  GetFoldersUseCase(this._behavior);

  @override
  Future<Result<List<FolderItem>>> call([_ = const NoParams()]) {
    return _behavior.getFolders();
  }
}
