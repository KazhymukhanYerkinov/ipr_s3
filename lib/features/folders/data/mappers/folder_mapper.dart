import 'package:ipr_s3/features/folders/data/dtos/folder_dto.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

class FolderMapper {
  static FolderItem fromDto(FolderDto dto, {List<FolderItem> children = const []}) {
    return FolderItem(
      id: dto.id,
      name: dto.name,
      parentId: dto.parentId,
      createdAt: dto.createdAt,
      children: children,
    );
  }

  static FolderDto toDto(FolderItem entity) {
    return FolderDto(
      id: entity.id,
      name: entity.name,
      parentId: entity.parentId,
      createdAt: entity.createdAt,
    );
  }
}
