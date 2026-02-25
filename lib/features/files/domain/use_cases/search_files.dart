import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@lazySingleton
class SearchFilesUseCase {
  final SearchFilesBehavior _behavior;

  SearchFilesUseCase(this._behavior);

  Future<Either<Failure, List<SecureFileEntity>>> call(String query) async {
    return _behavior.searchFiles(query);
  }
}
