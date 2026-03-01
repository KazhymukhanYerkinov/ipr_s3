import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/extensions/snack_bar_x.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/core/widgets/destructive_dialog.dart';
import 'package:ipr_s3/core/widgets/error_state_view.dart';
import 'package:ipr_s3/core/widgets/loading_state_view.dart';
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
    final l = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text(l.folders)),
      body: BlocConsumer<FoldersBloc, FoldersState>(
        listener: (context, state) {
          if (state is FoldersError) {
            context.showFloatingSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            FoldersLoading() => const LoadingStateView(),
            FoldersLoaded(:final folders) => FolderTreeWidget(
              folders: folders,
              onFolderDelete: (folder) => _confirmDelete(context, folder),
              onAddSubfolder:
                  (folder) => _showCreateDialog(context, parentId: folder.id),
            ),
            FoldersError() => ErrorStateView(
              message: l.somethingWentWrong,
              onRetry:
                  () => context.read<FoldersBloc>().add(FoldersLoadRequested()),
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
                    FolderCreateRequested(name: name, parentId: parentId),
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

  void _confirmDelete(BuildContext context, FolderItem folder) async {
    final l = context.locale;
    final confirmed = await showDestructiveDialog(
      context,
      title: l.deleteFolderTitle,
      content: l.deleteFolderContent(folder.name),
      confirmLabel: l.delete,
    );

    if (!confirmed || !context.mounted) return;

    context.read<FoldersBloc>().add(FolderDeleteRequested(folder.id));
  }
}
