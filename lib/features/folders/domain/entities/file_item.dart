import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/folders/domain/entities/file_system_item.dart';

/// Composite leaf — обёртка над [SecureFileEntity].
///
/// Представляет конечный элемент дерева (не имеет children).
/// [totalSize] возвращает размер одного файла,
/// [totalFiles] всегда равен 1.
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
