import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class SecureFileMapper {
  static SecureFileEntity fromDto(SecureFileDto dto) {
    return SecureFileEntity(
      id: dto.id,
      name: dto.name,
      type: FileType.values[dto.typeIndex],
      size: dto.size,
      encryptedPath: dto.encryptedPath,
      thumbnailPath: dto.thumbnailPath,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      tags: dto.tags,
      folderId: dto.folderId,
      checksum: dto.checksum,
    );
  }

  static SecureFileDto toDto(SecureFileEntity entity) {
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
      checksum: entity.checksum,
    );
  }
}
