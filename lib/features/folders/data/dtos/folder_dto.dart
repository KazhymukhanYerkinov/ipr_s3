import 'package:hive/hive.dart';
import 'package:ipr_s3/features/folders/data/mappers/folder_mapper.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

part 'folder_dto.g.dart';

@HiveType(typeId: 1)
class FolderDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? parentId;

  @HiveField(3)
  final DateTime createdAt;

  FolderDto({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
  });

  factory FolderDto.fromEntity(FolderItem entity) {
    return FolderMapper.toDto(entity);
  }

  FolderItem toEntity({List<FolderItem> children = const []}) {
    return FolderMapper.fromDto(this, children: children);
  }
}
