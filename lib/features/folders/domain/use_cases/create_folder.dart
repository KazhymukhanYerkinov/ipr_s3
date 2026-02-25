import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

@injectable
class CreateFolderUseCase {
  final CreateFolderBehavior _behavior;

  CreateFolderUseCase(this._behavior);

  Future<Either<Failure, FolderItem>> call({
    required String name,
    String? parentId,
  }) {
    return _behavior.createFolder(name: name, parentId: parentId);
  }
}
