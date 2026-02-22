import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';

@lazySingleton
class DeleteFileUseCase {
  final FilesBehavior _filesBehavior;

  DeleteFileUseCase(this._filesBehavior);

  Future<Either<Failure, void>> call(String fileId) async {
    return _filesBehavior.deleteFile(fileId);
  }
}
