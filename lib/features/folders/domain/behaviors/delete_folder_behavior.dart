import 'package:ipr_s3/core/result/result.dart';

abstract class DeleteFolderBehavior {
  Future<Result<void>> deleteFolder(String folderId);
}
