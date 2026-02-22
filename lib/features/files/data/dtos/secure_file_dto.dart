import 'package:hive/hive.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

part 'secure_file_dto.g.dart';

@HiveType(typeId: 0)
class SecureFileDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int typeIndex;

  @HiveField(3)
  final int size;

  @HiveField(4)
  final String encryptedPath;

  @HiveField(5)
  final String? thumbnailPath;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  @HiveField(8)
  final List<String> tags;

  @HiveField(9)
  final String? folderId;

  SecureFileDto({
    required this.id,
    required this.name,
    required this.typeIndex,
    required this.size,
    required this.encryptedPath,
    this.thumbnailPath,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.folderId,
  });

  factory SecureFileDto.fromEntity(SecureFileEntity entity) {
    return SecureFileDto(
      id: entity.id,
      name: entity.name,
      typeIndex: entity.type.index,
      size: entity.size,
      encryptedPath: entity.encryptedPath,
      thumbnailPath: entity.thumbnailPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      tags: entity.tags,
      folderId: entity.folderId,
    );
  }

  SecureFileEntity toEntity() {
    return SecureFileEntity(
      id: id,
      name: name,
      type: FileType.values[typeIndex],
      size: size,
      encryptedPath: encryptedPath,
      thumbnailPath: thumbnailPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      folderId: folderId,
    );
  }
}
