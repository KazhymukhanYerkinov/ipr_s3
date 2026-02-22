import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

@lazySingleton
class SearchFilesUseCase {
  final FilesBehavior _filesBehavior;

  SearchFilesUseCase(this._filesBehavior);

  Future<Either<Failure, List<SecureFileEntity>>> call(String query) async {
    return _filesBehavior.searchFiles(query);
  }
}
