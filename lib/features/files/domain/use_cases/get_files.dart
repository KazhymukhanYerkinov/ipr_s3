import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

@lazySingleton
class GetFilesUseCase {
  final FilesBehavior _filesBehavior;

  GetFilesUseCase(this._filesBehavior);

  Future<Either<Failure, List<SecureFileEntity>>> call() async {
    return _filesBehavior.getFiles();
  }
}
