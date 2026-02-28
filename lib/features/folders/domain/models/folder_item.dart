import 'package:ipr_s3/features/folders/domain/models/file_system_item.dart';

class FolderItem implements FileSystemItem {
  @override
  final String id;

  @override
  final String name;

  final String? parentId;
  final DateTime createdAt;
  final List<FileSystemItem> children;

  const FolderItem({
    required this.id,
    required this.name,
    this.parentId,
    required this.createdAt,
    this.children = const [],
  });

  @override
  int get totalSize =>
      children.fold<int>(0, (sum, item) => sum + item.totalSize);

  @override
  int get totalFiles =>
      children.fold<int>(0, (sum, item) => sum + item.totalFiles);

  FolderItem copyWith({
    String? id,
    String? name,
    String? parentId,
    DateTime? createdAt,
    List<FileSystemItem>? children,
  }) {
    return FolderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      children: children ?? this.children,
    );
  }
}
