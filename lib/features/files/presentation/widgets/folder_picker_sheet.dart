import 'package:flutter/material.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

class FolderPickerSheet extends StatelessWidget {
  final ThemeData theme;

  const FolderPickerSheet({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final l = context.locale;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(Icons.folder_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(l.importToFolder, style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.file_download_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            title: Text(l.noFolder),
            onTap: () => Navigator.pop(context, ''),
          ),
          FutureBuilder(
            future: getIt<GetFoldersBehavior>().getFolders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final folders = snapshot.data?.value ?? <FolderItem>[];

              if (folders.isEmpty) {
                return const SizedBox.shrink();
              }

              final flat = <_FlatFolder>[];
              _flatten(folders, flat, 0);

              return Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: flat.length,
                  itemBuilder: (context, index) {
                    final item = flat[index];
                    return ListTile(
                      contentPadding: EdgeInsets.only(
                        left: 16.0 + item.depth * 24.0,
                        right: 16,
                      ),
                      leading: Icon(
                        Icons.folder_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(item.folder.name),
                      onTap: () => Navigator.pop(context, item.folder.id),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _flatten(
    List<FolderItem> folders,
    List<_FlatFolder> result,
    int depth,
  ) {
    for (final folder in folders) {
      result.add(_FlatFolder(folder: folder, depth: depth));
      final subFolders = folder.children.whereType<FolderItem>().toList();
      if (subFolders.isNotEmpty) {
        _flatten(subFolders, result, depth + 1);
      }
    }
  }
}

class _FlatFolder {
  final FolderItem folder;
  final int depth;
  const _FlatFolder({required this.folder, required this.depth});
}
