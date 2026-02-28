import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/folders/domain/models/file_system_item.dart';

class FileItem implements FileSystemItem {
  final SecureFileEntity entity;

  const FileItem(this.entity);

  @override
  String get id => entity.id;

  @override
  String get name => entity.name;

  @override
  int get totalSize => entity.size;

  @override
  int get totalFiles => 1;
}
