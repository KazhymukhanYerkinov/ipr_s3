import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ipr_s3/core/error/exceptions.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/platform/native_hash_service.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';
import 'package:ipr_s3/features/files/data/services/file_search_service.dart';
import 'package:ipr_s3/features/files/data/services/thumbnail_service.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/behaviors/search_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@lazySingleton
class FilesService
    implements
        GetFilesBehavior,
        ImportFileBehavior,
        DecryptFileBehavior,
        SearchFilesBehavior {
  final FilesLocalSource _localSource;
  final FileEncryptionService _encryptionService;
  final ThumbnailService _thumbnailService;
  final FileSearchService _searchService;
  final NativeHashService _nativeHashService;
  final _logger = SecureLogger();
  final _uuid = const Uuid();

  FilesService(
    this._localSource,
    this._encryptionService,
    this._thumbnailService,
    this._searchService,
    this._nativeHashService,
  );

  @override
  Future<Result<List<SecureFileEntity>>> getFiles() async {
    try {
      final files = await _localSource.getAll();
      return SuccessResult(files);
    } on EncryptionKeyLostException {
      _logger.error('Encryption key lost — cannot load files');
      return ErrorResult(
        const EncryptionFailure(
          message: 'Encryption key was lost. Files cannot be decrypted.',
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to get files', e, stackTrace);
      return ErrorResult(const CacheFailure(message: 'Failed to load files'));
    }
  }

  @override
  Future<Result<SecureFileEntity>> importFile({
    required String name,
    required Uint8List bytes,
    required FileType type,
    String? folderId,
  }) async {
    try {
      final fileId = _uuid.v4();
      final now = DateTime.now();

      final encryptedBytes = await _encryptionService.encrypt(bytes);
      final checksum = _nativeHashService.crc32(encryptedBytes);
      final encryptedPath = await _localSource.saveEncryptedFile(
        fileId,
        encryptedBytes,
      );

      String? thumbnailPath;
      if (type == FileType.image) {
        final thumbnail = await _thumbnailService.create(bytes);
        if (thumbnail != null) {
          final encryptedThumb = await _encryptionService.encrypt(thumbnail);
          thumbnailPath = await _localSource.saveThumbnail(
            fileId,
            encryptedThumb,
          );
        }
      }

      final entity = SecureFileEntity(
        id: fileId,
        name: name,
        type: type,
        size: bytes.length,
        encryptedPath: encryptedPath,
        thumbnailPath: thumbnailPath,
        createdAt: now,
        updatedAt: now,
        checksum: checksum,
        folderId: folderId,
      );

      await _localSource.save(entity);
      _logger.info('File imported successfully');
      return SuccessResult(entity);
    } catch (e, stackTrace) {
      _logger.error('Failed to import file', e, stackTrace);
      return ErrorResult(
        const EncryptionFailure(message: 'Failed to import file'),
      );
    }
  }

  @override
  Future<Result<Uint8List>> decryptFile(String fileId) async {
    try {
      final entity = await _localSource.getById(fileId);
      if (entity == null) {
        return ErrorResult(const FileFailure(message: 'File not found'));
      }

      final encryptedBytes = await _localSource.readEncryptedFile(
        entity.encryptedPath,
      );

      if (entity.checksum != null) {
        final currentChecksum = _nativeHashService.crc32(encryptedBytes);
        if (currentChecksum != entity.checksum) {
          _logger.error('File integrity check failed for [REDACTED_ID]');
          return ErrorResult(
            const FileFailure(
              message: 'File integrity check failed — data may be corrupted',
            ),
          );
        }
      }

      final decryptedBytes = await _encryptionService.decrypt(encryptedBytes);
      _logger.info('File decrypted successfully');
      return SuccessResult(decryptedBytes);
    } on EncryptionKeyLostException {
      _logger.error('Encryption key lost — cannot decrypt file');
      return ErrorResult(
        const EncryptionFailure(
          message: 'Encryption key was lost. File cannot be decrypted.',
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to decrypt file', e, stackTrace);
      return ErrorResult(
        const EncryptionFailure(message: 'Failed to decrypt file'),
      );
    }
  }

  @override
  Future<Result<List<SecureFileEntity>>> searchFiles(String query) =>
      runGuarded(
        action: () async {
          final allFiles = await _localSource.getAll();
          return _searchService.search(query, allFiles);
        },
        onError: () => const FileFailure(message: 'Search failed'),
        logger: _logger,
        errorMessage: 'Search failed',
      );
}
