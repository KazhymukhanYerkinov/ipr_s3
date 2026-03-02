import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/extensions/snack_bar_x.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/core/router/app_router.dart';
import 'package:ipr_s3/core/widgets/destructive_dialog.dart';
import 'package:ipr_s3/core/widgets/error_state_view.dart';
import 'package:ipr_s3/core/widgets/loading_state_view.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_state.dart';
import 'package:ipr_s3/features/files/presentation/widgets/empty_state.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_grid.dart';
import 'package:ipr_s3/features/files/presentation/widgets/search_bar_widget.dart';
import 'package:ipr_s3/features/files/presentation/widgets/sort_dropdown.dart';
import 'package:ipr_s3/features/files/presentation/widgets/folder_picker_sheet.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FilesBloc>()..add(FilesLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.fileSecure),
        actions: [
          SortDropdown(),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'folders':
                  context.pushRoute(const FolderTreeRoute());
                case 'stats':
                  context.pushRoute(const StatsRoute());
                case 'settings':
                  context.pushRoute(const SettingsRoute());
              }
            },
            itemBuilder:
                (_) => [
                  PopupMenuItem(
                    value: 'folders',
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l.folders),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'stats',
                    child: Row(
                      children: [
                        const Icon(Icons.bar_chart_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(l.statistics),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l.settings),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onSearch:
                (query) =>
                    context.read<FilesBloc>().add(FileSearchRequested(query)),
            onClear: () => context.read<FilesBloc>().add(FileSearchCleared()),
          ),
          Expanded(
            child: BlocConsumer<FilesBloc, FilesState>(
              listener: (context, state) {
                if (state is FilesError) {
                  context.showFloatingSnackBar(state.message);
                }
              },
              builder: (context, state) {
                return switch (state) {
                  FilesLoading() => const LoadingStateView(),
                  FilesImporting(:final fileName) => LoadingStateView(
                    message: l.encryptingFile(fileName),
                  ),
                  FilesLoaded(:final files) =>
                    files.isEmpty
                        ? EmptyState(theme: theme)
                        : FileGrid(
                          files: files,
                          onFileTap:
                              (file) => context.pushRoute(
                                FileViewerRoute(
                                  fileId: file.id,
                                  fileName: file.name,
                                ),
                              ),
                          onFileDelete: (file) => _confirmDelete(context, file),
                        ),
                  FilesError() => ErrorStateView(
                    message: l.somethingWentWrong,
                    onRetry:
                        () =>
                            context.read<FilesBloc>().add(FilesLoadRequested()),
                  ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFolderPickerAndImport(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _showFolderPickerAndImport(BuildContext context) async {
    final bloc = context.read<FilesBloc>();

    final folderId = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return FolderPickerSheet(theme: theme);
      },
    );

    if (folderId == null) return;
    bloc.add(FileImportRequested(folderId: folderId.isEmpty ? null : folderId));
  }

  void _confirmDelete(BuildContext context, SecureFileEntity file) async {
    final l = context.locale;
    final confirmed = await showDestructiveDialog(
      context,
      title: l.deleteFileTitle,
      content: l.deleteFileContent(file.name),
      confirmLabel: l.delete,
    );

    if (!confirmed || !context.mounted) return;

    final bloc = context.read<FilesBloc>();
    bloc.add(FileDeleteRequested(file));

    context.showFloatingSnackBar(
      l.fileDeleted(file.name),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.undo,
        onPressed: () => bloc.add(UndoRequested()),
      ),
    );
  }
}
