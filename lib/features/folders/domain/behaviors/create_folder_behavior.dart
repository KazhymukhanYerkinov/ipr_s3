import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

abstract class CreateFolderBehavior {
  Future<Result<FolderItem>> createFolder({
    required String name,
    String? parentId,
  });
}
