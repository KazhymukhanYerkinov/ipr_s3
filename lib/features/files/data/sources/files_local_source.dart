import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ipr_s3/core/security/encryption_helper.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

abstract class FilesLocalSource {
  Future<List<SecureFileEntity>> getAll();
  Future<SecureFileEntity?> getById(String id);
  Future<void> save(SecureFileEntity entity);
  Future<void> delete(String id);
  Future<String> saveEncryptedFile(String fileId, Uint8List data);
  Future<Uint8List> readEncryptedFile(String path);
  Future<void> deleteEncryptedFile(String path);
  Future<String> saveThumbnail(String fileId, Uint8List data);
}

@LazySingleton(as: FilesLocalSource)
class FilesLocalSourceImpl implements FilesLocalSource {
  static const _boxName = 'secure_files';

  final EncryptionHelper _encryptionHelper;
  final _logger = SecureLogger();

  FilesLocalSourceImpl(this._encryptionHelper);

  @override
  Future<List<SecureFileEntity>> getAll() async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(_boxName);
    return box.values.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<SecureFileEntity?> getById(String id) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(_boxName);
    final dto = box.get(id);
    return dto?.toEntity();
  }

  @override
  Future<void> save(SecureFileEntity entity) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(_boxName);
    final dto = SecureFileDto.fromEntity(entity);
    await box.put(entity.id, dto);
    _logger.info('File metadata saved: [REDACTED_PATH]');
  }

  @override
  Future<void> delete(String id) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(_boxName);
    final dto = box.get(id);

    if (dto != null) {
      await deleteEncryptedFile(dto.encryptedPath);
      if (dto.thumbnailPath != null) {
        await _deleteFileIfExists(dto.thumbnailPath!);
      }
      await box.delete(id);
      _logger.info('File deleted: [REDACTED_PATH]');
    }
  }

  @override
  Future<String> saveEncryptedFile(String fileId, Uint8List data) async {
    final dir = await _getSecureDirectory();
    final path = '${dir.path}/enc_$fileId';
    final file = File(path);
    await file.writeAsBytes(data);
    _logger.info('Encrypted file saved: [REDACTED_PATH]');
    return path;
  }

  @override
  Future<Uint8List> readEncryptedFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('Encrypted file not found', path);
    }
    return file.readAsBytes();
  }

  @override
  Future<void> deleteEncryptedFile(String path) async {
    await _deleteFileIfExists(path);
  }

  @override
  Future<String> saveThumbnail(String fileId, Uint8List data) async {
    final dir = await _getThumbnailDirectory();
    final path = '${dir.path}/thumb_$fileId.png';
    final file = File(path);
    await file.writeAsBytes(data);
    return path;
  }

  Future<Directory> _getSecureDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final secureDir = Directory('${appDir.path}/secure_files');
    if (!await secureDir.exists()) {
      await secureDir.create(recursive: true);
    }
    return secureDir;
  }

  Future<Directory> _getThumbnailDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final thumbDir = Directory('${appDir.path}/thumbnails');
    if (!await thumbDir.exists()) {
      await thumbDir.create(recursive: true);
    }
    return thumbDir;
  }

  Future<void> _deleteFileIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
