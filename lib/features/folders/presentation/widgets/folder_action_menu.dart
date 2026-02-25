import 'package:flutter/material.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

class FolderActionMenu extends StatelessWidget {
  final FolderItem folder;
  final void Function(FolderItem folder)? onDelete;
  final void Function(FolderItem folder)? onAddSubfolder;

  const FolderActionMenu({
    super.key,
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
