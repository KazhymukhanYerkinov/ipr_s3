import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/folders/domain/models/file_item.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/file_node_tile.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/folder_action_menu.dart';

class FolderNode extends StatelessWidget {
  final FolderItem folder;
  final int depth;
  final void Function(FolderItem folder)? onFolderTap;
  final void Function(FolderItem folder)? onFolderDelete;
  final void Function(FolderItem folder)? onAddSubfolder;
  final void Function(SecureFileEntity file)? onFileTap;

  const FolderNode({
    super.key,
    required this.folder,
    required this.depth,
    this.onFolderTap,
    this.onFolderDelete,
    this.onAddSubfolder,
    this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childFolders = folder.children.whereType<FolderItem>().toList();
    final childFiles = folder.children.whereType<FileItem>().toList();
    final hasChildren = childFolders.isNotEmpty || childFiles.isNotEmpty;

    final subtitle =
        '${folder.totalFiles} files'
        ' · ${formatSize(folder.totalSize)}';

    if (!hasChildren) {
      return ListTile(
        contentPadding: EdgeInsets.only(left: 16.0 + depth * 24.0, right: 8),
        leading: Icon(Icons.folder_rounded, color: theme.colorScheme.primary),
        title: Text(folder.name),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        onTap: onFolderTap != null ? () => onFolderTap!(folder) : null,
        trailing: FolderActionMenu(
          folder: folder,
          onDelete: onFolderDelete,
          onAddSubfolder: onAddSubfolder,
        ),
      );
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.only(left: 16.0 + depth * 24.0, right: 8),
      leading: Icon(Icons.folder_rounded, color: theme.colorScheme.primary),
      title: Text(folder.name),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FolderActionMenu(
            folder: folder,
            onDelete: onFolderDelete,
            onAddSubfolder: onAddSubfolder,
          ),
          const Icon(Icons.expand_more),
        ],
      ),
      children: [
        ...childFolders.map(
          (child) => FolderNode(
            folder: child,
            depth: depth + 1,
            onFolderTap: onFolderTap,
            onFolderDelete: onFolderDelete,
            onAddSubfolder: onAddSubfolder,
            onFileTap: onFileTap,
          ),
        ),
        ...childFiles.map(
          (fileItem) => FileNodeTile(
            fileItem: fileItem,
            depth: depth + 1,
            onTap: onFileTap,
          ),
        ),
      ],
    );
  }
}
