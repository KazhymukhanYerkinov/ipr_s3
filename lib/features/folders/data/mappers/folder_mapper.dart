import 'package:ipr_s3/features/folders/data/dtos/folder_dto.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

extension FolderDtoMapperX on FolderDto {
  FolderItem toEntity({List<FolderItem> children = const []}) {
    return FolderItem(
      id: id,
      name: name,
      parentId: parentId,
      createdAt: createdAt,
      children: children,
    );
  }
}

extension FolderItemMapperX on FolderItem {
  FolderDto toDto() {
    return FolderDto(
      id: id,
      name: name,
      parentId: parentId,
      createdAt: createdAt,
    );
  }
}
