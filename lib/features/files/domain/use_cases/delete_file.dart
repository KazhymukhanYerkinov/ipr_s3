import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/delete_file_behavior.dart';

@lazySingleton
class DeleteFileUseCase {
  final DeleteFileBehavior _behavior;

  DeleteFileUseCase(this._behavior);

  Future<Either<Failure, void>> call(String fileId) async {
    return _behavior.deleteFile(fileId);
  }
}
