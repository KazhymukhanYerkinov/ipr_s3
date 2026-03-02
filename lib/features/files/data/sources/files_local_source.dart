import 'dart:typed_data';

import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class FilesLocalSource {
  Future<List<SecureFileEntity>> getAll();
  Future<SecureFileEntity?> getById(String id);
  Future<void> save(SecureFileEntity entity);
  Future<void> delete(String id);
  Future<String> saveEncryptedFile(String fileId, Uint8List data);
  Future<Uint8List> readEncryptedFile(String path);
  Future<void> deleteEncryptedFile(String path);
  Future<String> saveThumbnail(String fileId, Uint8List data);
  Future<Uint8List?> readThumbnail(String path);
}
