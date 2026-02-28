import 'package:ipr_s3/core/result/result.dart';

abstract class MoveFileToFolderBehavior {
  Future<Result<void>> moveFileToFolder({
    required String fileId,
    required String? folderId,
  });
}
