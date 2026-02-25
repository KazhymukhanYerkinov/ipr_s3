import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@lazySingleton
class GetFilesUseCase {
  final GetFilesBehavior _behavior;

  GetFilesUseCase(this._behavior);

  Future<Either<Failure, List<SecureFileEntity>>> call() async {
    return _behavior.getFiles();
  }
}
