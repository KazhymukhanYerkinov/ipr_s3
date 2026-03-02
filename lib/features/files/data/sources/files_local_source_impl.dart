import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ipr_s3/core/security/encryption_helper.dart';
import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/files/data/mappers/secure_file_mapper.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@LazySingleton(as: FilesLocalSource)
class FilesLocalSourceImpl implements FilesLocalSource {
  static const _boxName = 'secure_files';

  final EncryptionHelper _encryptionHelper;

  FilesLocalSourceImpl(this._encryptionHelper);

  @override
  Future<List<SecureFileEntity>> getAll() async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(
      _boxName,
    );
    return box.values.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<SecureFileEntity?> getById(String id) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(
      _boxName,
    );
    final dto = box.get(id);
    return dto?.toEntity();
  }

  @override
  Future<void> save(SecureFileEntity entity) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(
      _boxName,
    );
    final dto = SecureFileDto.fromEntity(entity);
    await box.put(entity.id, dto);
  }

  @override
  Future<void> delete(String id) async {
    final box = await _encryptionHelper.openEncryptedBox<SecureFileDto>(
      _boxName,
    );
    final dto = box.get(id);

    if (dto != null) {
      await deleteEncryptedFile(dto.encryptedPath);
      if (dto.thumbnailPath != null) {
        final thumbPath = await _resolveThumbnailPath(dto.thumbnailPath!);
        await _deleteFileIfExists(thumbPath);
      }
      await box.delete(id);
    }
  }

  @override
  Future<String> saveEncryptedFile(String fileId, Uint8List data) async {
    final dir = await _getSecureDirectory();
    final fileName = 'enc_$fileId';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(data);
    return fileName;
  }

  @override
  Future<Uint8List> readEncryptedFile(String path) async {
    final fullPath = await _resolveSecureFilePath(path);
    final file = File(fullPath);
    if (!await file.exists()) {
      throw FileSystemException('Encrypted file not found', fullPath);
    }
    return file.readAsBytes();
  }

  @override
  Future<void> deleteEncryptedFile(String path) async {
    final fullPath = await _resolveSecureFilePath(path);
    await _deleteFileIfExists(fullPath);
  }

  @override
  Future<String> saveThumbnail(String fileId, Uint8List data) async {
    final dir = await _getThumbnailDirectory();
    final fileName = 'thumb_$fileId.png';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(data);
    return fileName;
  }

  @override
  Future<Uint8List?> readThumbnail(String path) async {
    try {
      final fullPath = await _resolveThumbnailPath(path);
      final file = File(fullPath);
      if (!await file.exists()) return null;
      return file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<String> _resolveSecureFilePath(String path) async {
    if (path.startsWith('/')) {
      if (await File(path).exists()) return path;
      final fileName = path.split('/').last;
      final dir = await _getSecureDirectory();
      return '${dir.path}/$fileName';
    }
    final dir = await _getSecureDirectory();
    return '${dir.path}/$path';
  }

  Future<String> _resolveThumbnailPath(String path) async {
    if (path.startsWith('/')) {
      if (await File(path).exists()) return path;
      final fileName = path.split('/').last;
      final dir = await _getThumbnailDirectory();
      return '${dir.path}/$fileName';
    }
    final dir = await _getThumbnailDirectory();
    return '${dir.path}/$path';
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
