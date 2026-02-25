import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_bloc.dart';
import 'package:ipr_s3/features/folders/presentation/widgets/folder_tree_widget.dart';

@RoutePage()
class FolderTreeScreen extends StatelessWidget {
  const FolderTreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FoldersBloc>()..add(FoldersLoadRequested()),
      child: const _FolderTreeView(),
    );
  }
}

class _FolderTreeView extends StatelessWidget {
  const _FolderTreeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Folders'),
      ),
      body: BlocConsumer<FoldersBloc, FoldersState>(
        listener: (context, state) {
          if (state is FoldersError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ));
          }
        },
        builder: (context, state) {
          return switch (state) {
            FoldersLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            FoldersLoaded(:final folders) => FolderTreeWidget(
                folders: folders,
                onFolderDelete: (folder) =>
                    _confirmDelete(context, folder),
                onAddSubfolder: (folder) =>
                    _showCreateDialog(context, parentId: folder.id),
              ),
            FoldersError() => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text('Something went wrong',
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context
                          .read<FoldersBloc>()
                          .add(FoldersLoadRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.create_new_folder_rounded),
      ),
    );
  }

  void _showCreateDialog(BuildContext context, {String? parentId}) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(parentId != null ? 'New Subfolder' : 'New Folder'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Folder name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  context.read<FoldersBloc>().add(
                        FolderCreateRequested(
                          name: name,
                          parentId: parentId,
                        ),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }

  void _confirmDelete(BuildContext context, FolderItem folder) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: const Text('Delete folder?'),
          content: Text(
            'This will permanently delete "${folder.name}" '
            'and all subfolders.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context
                    .read<FoldersBloc>()
                    .add(FolderDeleteRequested(folder.id));
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
