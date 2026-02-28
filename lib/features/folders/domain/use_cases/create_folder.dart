import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

class CreateFolderParams {
  final String name;
  final String? parentId;

  CreateFolderParams({required this.name, this.parentId});
}

@injectable
class CreateFolderUseCase implements Callable<CreateFolderParams, FolderItem> {
  final CreateFolderBehavior _behavior;

  CreateFolderUseCase(this._behavior);

  @override
  Future<Result<FolderItem>> call(CreateFolderParams params) {
    return _behavior.createFolder(name: params.name, parentId: params.parentId);
  }
}
