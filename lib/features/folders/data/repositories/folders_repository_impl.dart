import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/folders/data/sources/folders_local_source.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';

@LazySingleton(as: FoldersBehavior)
class FoldersRepositoryImpl implements FoldersBehavior {
  final FoldersLocalSource _foldersSource;
  final FilesLocalSource _filesSource;
  final _logger = SecureLogger();
  final _uuid = const Uuid();

  FoldersRepositoryImpl(this._foldersSource, this._filesSource);

  @override
  Future<Either<Failure, List<FolderItem>>> getFolders() async {
    try {
      final folders = await _foldersSource.getAll();
      return Right(folders);
    } catch (e, st) {
      _logger.error('Failed to get folders', e, st);
      return const Left(CacheFailure(message: 'Failed to load folders'));
    }
  }

  @override
  Future<Either<Failure, FolderItem>> createFolder({
    required String name,
    String? parentId,
  }) async {
    try {
      final folder = FolderItem(
        id: _uuid.v4(),
        name: name,
        parentId: parentId,
        createdAt: DateTime.now(),
      );
      await _foldersSource.save(folder);
      _logger.info('Folder created');
      return Right(folder);
    } catch (e, st) {
      _logger.error('Failed to create folder', e, st);
      return const Left(CacheFailure(message: 'Failed to create folder'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFolder(String folderId) async {
    try {
      await _foldersSource.delete(folderId);
      _logger.info('Folder deleted');
      return const Right(null);
    } catch (e, st) {
      _logger.error('Failed to delete folder', e, st);
      return const Left(CacheFailure(message: 'Failed to delete folder'));
    }
  }

  @override
  Future<Either<Failure, void>> moveFileToFolder({
    required String fileId,
    required String? folderId,
  }) async {
    try {
      final file = await _filesSource.getById(fileId);
      if (file == null) {
        return const Left(FileFailure(message: 'File not found'));
      }

      final updated = file.copyWith(folderId: folderId);
      await _filesSource.save(updated);
      _logger.info('File moved to folder');
      return const Right(null);
    } catch (e, st) {
      _logger.error('Failed to move file', e, st);
      return const Left(FileFailure(message: 'Failed to move file'));
    }
  }
}
