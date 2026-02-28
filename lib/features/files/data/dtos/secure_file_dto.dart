import 'package:hive/hive.dart';
import 'package:ipr_s3/features/files/data/mappers/secure_file_mapper.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

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

  @HiveField(10)
  final int? checksum;

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
    this.checksum,
  });

  factory SecureFileDto.fromEntity(SecureFileEntity entity) {
    return entity.toDto();
  }
}
