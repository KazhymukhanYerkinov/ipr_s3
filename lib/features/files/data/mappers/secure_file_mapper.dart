import 'package:ipr_s3/features/files/data/dtos/secure_file_dto.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

extension SecureFileDtoMapperX on SecureFileDto {
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
      checksum: checksum,
    );
  }
}

extension SecureFileEntityMapperX on SecureFileEntity {
  SecureFileDto toDto() {
    return SecureFileDto(
      id: id,
      name: name,
      typeIndex: type.index,
      size: size,
      encryptedPath: encryptedPath,
      thumbnailPath: thumbnailPath,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      folderId: folderId,
      checksum: checksum,
    );
  }
}
