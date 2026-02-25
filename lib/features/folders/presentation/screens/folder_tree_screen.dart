import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_bloc.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_event.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_state.dart';
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
    final l = context.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.folders),
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
                    Text(l.somethingWentWrong,
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context
                          .read<FoldersBloc>()
                          .add(FoldersLoadRequested()),
                      child: Text(l.retry),
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
    final l = context.locale;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(parentId != null ? l.newSubfolder : l.newFolder),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l.folderName,
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancel),
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
              child: Text(l.create),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FolderItem folder) {
    final l = context.locale;
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l.deleteFolderTitle),
          content: Text(
            l.deleteFolderContent(folder.name),
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l.cancel),
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
              child: Text(l.delete),
            ),
          ],
        );
      },
    );
  }
}
