import 'package:flutter/material.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/folder_node.dart';

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
      itemBuilder: (context, index) => FolderNode(
        folder: folders[index],
        depth: 0,
        onFolderTap: onFolderTap,
        onFolderDelete: onFolderDelete,
        onAddSubfolder: onAddSubfolder,
      ),
    );
  }
}
