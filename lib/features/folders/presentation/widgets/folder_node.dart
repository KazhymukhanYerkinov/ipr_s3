import 'package:flutter/material.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/folder_action_menu.dart';

class FolderNode extends StatelessWidget {
  final FolderItem folder;
  final int depth;
  final void Function(FolderItem folder)? onFolderTap;
  final void Function(FolderItem folder)? onFolderDelete;
  final void Function(FolderItem folder)? onAddSubfolder;

  const FolderNode({
    super.key,
    required this.folder,
    required this.depth,
    this.onFolderTap,
    this.onFolderDelete,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childFolders = folder.children.whereType<FolderItem>().toList();
    final hasChildren = childFolders.isNotEmpty;

    final subtitle = '${folder.totalFiles} files'
        ' · ${_formatSize(folder.totalSize)}';

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
      children: childFolders
          .map((child) => FolderNode(
                folder: child,
                depth: depth + 1,
                onFolderTap: onFolderTap,
                onFolderDelete: onFolderDelete,
                onAddSubfolder: onAddSubfolder,
              ))
          .toList(),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
