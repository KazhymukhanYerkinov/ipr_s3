import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/folder_node.dart';

class FolderTreeWidget extends StatelessWidget {
  final List<FolderItem> folders;
  final void Function(FolderItem folder)? onFolderTap;
  final void Function(FolderItem folder)? onFolderDelete;
  final void Function(FolderItem folder)? onAddSubfolder;
  final void Function(SecureFileEntity file)? onFileTap;

  const FolderTreeWidget({
    super.key,
    required this.folders,
    this.onFolderTap,
    this.onFolderDelete,
    this.onAddSubfolder,
    this.onFileTap,
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
      itemBuilder:
          (context, index) => FolderNode(
            folder: folders[index],
            depth: 0,
            onFolderTap: onFolderTap,
            onFolderDelete: onFolderDelete,
            onAddSubfolder: onAddSubfolder,
            onFileTap: onFileTap,
          ),
    );
  }
}
