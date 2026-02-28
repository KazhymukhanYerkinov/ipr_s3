enum FileType { image, pdf, text, video, audio, unknown }

class SecureFileEntity {
  final String id;
  final String name;
  final FileType type;
  final int size;
  final String encryptedPath;
  final String? thumbnailPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String? folderId;
  final int? checksum;

  const SecureFileEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.encryptedPath,
    this.thumbnailPath,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.folderId,
    this.checksum,
  });

  SecureFileEntity copyWith({
    String? id,
    String? name,
    FileType? type,
    int? size,
    String? encryptedPath,
    String? thumbnailPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? folderId,
    int? checksum,
  }) {
    return SecureFileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      encryptedPath: encryptedPath ?? this.encryptedPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      folderId: folderId ?? this.folderId,
      checksum: checksum ?? this.checksum,
    );
  }
}
