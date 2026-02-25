import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class SearchFilesBehavior {
  Future<Either<Failure, List<SecureFileEntity>>> searchFiles(String query);
}
