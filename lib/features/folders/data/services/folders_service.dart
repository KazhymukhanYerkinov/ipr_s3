import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/security/secure_logger.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/folders/data/sources/folders_local_source.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/create_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/delete_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/move_file_to_folder_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/file_item.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

@lazySingleton
class FoldersService
    implements
        GetFoldersBehavior,
        CreateFolderBehavior,
        DeleteFolderBehavior,
        MoveFileToFolderBehavior {
  final FoldersLocalSource _foldersSource;
  final FilesLocalSource _filesSource;
  final _logger = SecureLogger();
  final _uuid = const Uuid();

  FoldersService(this._foldersSource, this._filesSource);

  @override
  Future<Result<List<FolderItem>>> getFolders() async {
    try {
      final folders = await _foldersSource.getAll();
      final files = await _filesSource.getAll();

      final filesByFolder = <String, List<FileItem>>{};
      for (final file in files) {
        if (file.folderId != null) {
          filesByFolder
              .putIfAbsent(file.folderId!, () => [])
              .add(FileItem(file));
        }
      }

      final enriched =
          folders.map((f) => _injectFiles(f, filesByFolder)).toList();
      return SuccessResult(enriched);
    } catch (e, st) {
      _logger.error('Failed to get folders', e, st);
      return ErrorResult(const CacheFailure(message: 'Failed to load folders'));
    }
  }

  FolderItem _injectFiles(
    FolderItem folder,
    Map<String, List<FileItem>> filesByFolder,
  ) {
    final updatedChildren =
        folder.children.map((child) {
          if (child is FolderItem) return _injectFiles(child, filesByFolder);
          return child;
        }).toList();

    final folderFiles = filesByFolder[folder.id] ?? [];
    return folder.copyWith(children: [...updatedChildren, ...folderFiles]);
  }

  @override
  Future<Result<FolderItem>> createFolder({
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
      return SuccessResult(folder);
    } catch (e, st) {
      _logger.error('Failed to create folder', e, st);
      return ErrorResult(
        const CacheFailure(message: 'Failed to create folder'),
      );
    }
  }

  @override
  Future<Result<void>> deleteFolder(String folderId) async {
    try {
      await _foldersSource.delete(folderId);
      _logger.info('Folder deleted');
      return SuccessResult(null);
    } catch (e, st) {
      _logger.error('Failed to delete folder', e, st);
      return ErrorResult(
        const CacheFailure(message: 'Failed to delete folder'),
      );
    }
  }

  @override
  Future<Result<void>> moveFileToFolder({
    required String fileId,
    required String? folderId,
  }) async {
    try {
      final file = await _filesSource.getById(fileId);
      if (file == null) {
        return ErrorResult(const FileFailure(message: 'File not found'));
      }

      final updated = file.copyWith(folderId: folderId);
      await _filesSource.save(updated);
      _logger.info('File moved to folder');
      return SuccessResult(null);
    } catch (e, st) {
      _logger.error('Failed to move file', e, st);
      return ErrorResult(const FileFailure(message: 'Failed to move file'));
    }
  }
}
