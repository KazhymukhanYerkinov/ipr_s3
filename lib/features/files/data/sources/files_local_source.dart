import 'package:ipr_s3/features/files/domain/behaviors/file_storage_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class FilesLocalSource implements FileStorageBehavior {
  Future<List<SecureFileEntity>> getAll();
  Future<void> deleteEncryptedFile(String path);
}
