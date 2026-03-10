import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/constants/storage_keys.dart';
import 'package:ipr_s3/core/security/encryption_helper.dart';
import 'package:ipr_s3/features/folders/data/dtos/folder_dto.dart';
import 'package:ipr_s3/features/folders/data/mappers/folder_mapper.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

abstract class FoldersLocalSource {
  Future<List<FolderItem>> getAll();
  Future<void> save(FolderItem folder);
  Future<void> delete(String folderId);
}

@LazySingleton(as: FoldersLocalSource)
class FoldersLocalSourceImpl implements FoldersLocalSource {
  static const _boxName = StorageKeys.foldersBox;

  final EncryptionHelper _encryptionHelper;

  FoldersLocalSourceImpl(this._encryptionHelper);

  @override
  Future<List<FolderItem>> getAll() async {
    final box = await _encryptionHelper.openEncryptedBox<FolderDto>(_boxName);
    final dtos = box.values.toList();

    final flatFolders = {for (final dto in dtos) dto.id: dto.toEntity()};

    return _buildTree(flatFolders);
  }

  List<FolderItem> _buildTree(Map<String, FolderItem> flatMap) {
    final roots = <FolderItem>[];
    final childrenMap = <String, List<FolderItem>>{};

    for (final folder in flatMap.values) {
      if (folder.parentId != null) {
        childrenMap.putIfAbsent(folder.parentId!, () => []).add(folder);
      }
    }

    FolderItem attachChildren(FolderItem folder) {
      final kids = childrenMap[folder.id] ?? [];
      return folder.copyWith(children: kids.map(attachChildren).toList());
    }

    for (final folder in flatMap.values) {
      if (folder.parentId == null) {
        roots.add(attachChildren(folder));
      }
    }

    return roots;
  }

  @override
  Future<void> save(FolderItem folder) async {
    final box = await _encryptionHelper.openEncryptedBox<FolderDto>(_boxName);
    await box.put(folder.id, folder.toDto());
  }

  @override
  Future<void> delete(String folderId) async {
    final box = await _encryptionHelper.openEncryptedBox<FolderDto>(_boxName);
    await box.delete(folderId);

    final childDtos =
        box.values.where((dto) => dto.parentId == folderId).toList();
    for (final child in childDtos) {
      await delete(child.id);
    }
  }
}
