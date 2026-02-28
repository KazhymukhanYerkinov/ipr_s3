import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class GetFilesBehavior {
  Future<Result<List<SecureFileEntity>>> getFiles();
}
