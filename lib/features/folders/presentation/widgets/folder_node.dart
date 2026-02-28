import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/folders/domain/models/file_item.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
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
          (fileItem) => _FileNodeTile(
            fileItem: fileItem,
            depth: depth + 1,
            onTap: onFileTap,
          ),
        ),
      ],
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

class _FileNodeTile extends StatelessWidget {
  final FileItem fileItem;
  final int depth;
  final void Function(SecureFileEntity file)? onTap;

  const _FileNodeTile({
    required this.fileItem,
    required this.depth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entity = fileItem.entity;

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + depth * 24.0, right: 8),
      leading: Icon(_iconForType(entity.type), color: theme.colorScheme.secondary),
      title: Text(entity.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        _formatSize(entity.size),
        style: theme.textTheme.bodySmall,
      ),
      onTap: onTap != null ? () => onTap!(entity) : null,
    );
  }

  IconData _iconForType(FileType type) {
    return switch (type) {
      FileType.image => Icons.image_rounded,
      FileType.pdf => Icons.picture_as_pdf_rounded,
      FileType.text => Icons.description_rounded,
      FileType.video => Icons.videocam_rounded,
      FileType.audio => Icons.audiotrack_rounded,
      FileType.unknown => Icons.insert_drive_file_rounded,
    };
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
