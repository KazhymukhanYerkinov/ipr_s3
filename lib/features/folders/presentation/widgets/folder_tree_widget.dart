import 'package:flutter/material.dart';
import 'package:ipr_s3/features/folders/domain/entities/file_system_item.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';

/// Рекурсивный виджет для отображения дерева папок (Composite pattern).
///
/// Каждый [FolderItem] рендерится как [ExpansionTile] и рекурсивно
/// строит children. Показывает totalFiles и totalSize через Composite.
class FolderTreeWidget extends StatelessWidget {
  final List<FolderItem> folders;
  final void Function(FolderItem folder)? onFolderTap;
  final void Function(FolderItem folder)? onFolderDelete;
  final void Function(FolderItem folder)? onAddSubfolder;

  const FolderTreeWidget({
    super.key,
    required this.folders,
    this.onFolderTap,
    this.onFolderDelete,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.folder_off_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'No folders yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: folders.length,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemBuilder: (context, index) => _FolderNode(
        folder: folders[index],
        depth: 0,
        onFolderTap: onFolderTap,
        onFolderDelete: onFolderDelete,
        onAddSubfolder: onAddSubfolder,
      ),
    );
  }
}

class _FolderNode extends StatelessWidget {
  final FolderItem folder;
  final int depth;
  final void Function(FolderItem folder)? onFolderTap;
  final void Function(FolderItem folder)? onFolderDelete;
  final void Function(FolderItem folder)? onAddSubfolder;

  const _FolderNode({
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
        trailing: _ActionMenu(
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
          _ActionMenu(
            folder: folder,
            onDelete: onFolderDelete,
            onAddSubfolder: onAddSubfolder,
          ),
          const Icon(Icons.expand_more),
        ],
      ),
      children: childFolders
          .map((child) => _FolderNode(
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

class _ActionMenu extends StatelessWidget {
  final FolderItem folder;
  final void Function(FolderItem folder)? onDelete;
  final void Function(FolderItem folder)? onAddSubfolder;

  const _ActionMenu({
    required this.folder,
    this.onDelete,
    this.onAddSubfolder,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'add_subfolder',
          child: Row(
            children: [
              Icon(Icons.create_new_folder_outlined, size: 20),
              SizedBox(width: 8),
              Text('Add subfolder'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'add_subfolder':
            onAddSubfolder?.call(folder);
          case 'delete':
            onDelete?.call(folder);
        }
      },
      icon: const Icon(Icons.more_vert, size: 20),
      padding: EdgeInsets.zero,
    );
  }
}
