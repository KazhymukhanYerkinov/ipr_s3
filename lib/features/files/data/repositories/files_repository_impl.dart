import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';
import 'package:ipr_s3/features/files/data/services/file_search_service.dart';
import 'package:ipr_s3/features/files/data/services/thumbnail_service.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

@LazySingleton(as: FilesBehavior)
class FilesRepositoryImpl implements FilesBehavior {
  final FilesLocalSource _localSource;
  final FileEncryptionService _encryptionService;
  final ThumbnailService _thumbnailService;
  final FileSearchService _searchService;
  final _logger = SecureLogger();
  final _uuid = const Uuid();

  FilesRepositoryImpl(
    this._localSource,
    this._encryptionService,
    this._thumbnailService,
    this._searchService,
  );

  @override
  Future<Either<Failure, List<SecureFileEntity>>> getFiles() async {
    try {
      final files = await _localSource.getAll();
      return Right(files);
    } catch (e, stackTrace) {
      _logger.error('Failed to get files', e, stackTrace);
      return const Left(CacheFailure(message: 'Failed to load files'));
    }
  }

  @override
  Future<Either<Failure, SecureFileEntity>> importFile({
    required String name,
    required Uint8List bytes,
    required FileType type,
  }) async {
    try {
      final fileId = _uuid.v4();
      final now = DateTime.now();

      final encryptedBytes = await _encryptionService.encrypt(bytes);
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
      );

      await _localSource.save(entity);
      _logger.info('File imported successfully');
      return Right(entity);
    } catch (e, stackTrace) {
      _logger.error('Failed to import file', e, stackTrace);
      return const Left(EncryptionFailure(message: 'Failed to import file'));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> decryptFile(String fileId) async {
    try {
      final entity = await _localSource.getById(fileId);
      if (entity == null) {
        return const Left(FileFailure(message: 'File not found'));
      }

      final encryptedBytes = await _localSource.readEncryptedFile(
        entity.encryptedPath,
      );
      final decryptedBytes = await _encryptionService.decrypt(encryptedBytes);
      _logger.info('File decrypted successfully');
      return Right(decryptedBytes);
    } catch (e, stackTrace) {
      _logger.error('Failed to decrypt file', e, stackTrace);
      return const Left(EncryptionFailure(message: 'Failed to decrypt file'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFile(String fileId) async {
    try {
      await _localSource.delete(fileId);
      _logger.info('File deleted successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      _logger.error('Failed to delete file', e, stackTrace);
      return const Left(FileFailure(message: 'Failed to delete file'));
    }
  }

  @override
  Future<Either<Failure, List<SecureFileEntity>>> searchFiles(
    String query,
  ) async {
    try {
      final allFiles = await _localSource.getAll();
      final results = await _searchService.search(query, allFiles);
      return Right(results);
    } catch (e, stackTrace) {
      _logger.error('Search failed', e, stackTrace);
      return const Left(FileFailure(message: 'Search failed'));
    }
  }
}
