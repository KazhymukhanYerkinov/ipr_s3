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
import 'package:ipr_s3/features/files/presentation/widgets/file_list_view.dart';
import 'package:ipr_s3/features/files/presentation/widgets/search_bar_widget.dart';
import 'package:ipr_s3/features/files/presentation/widgets/sort_dropdown.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

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
          BlocSelector<FilesBloc, FilesState, ViewMode?>(
            selector: (state) => state is FilesLoaded ? state.viewMode : null,
            builder: (context, viewMode) {
              return IconButton(
                onPressed:
                    () => context.read<FilesBloc>().add(ViewModeToggled()),
                icon: Icon(
                  viewMode == ViewMode.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                ),
              );
            },
          ),
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
                  FilesLoaded(:final files, :final viewMode) =>
                    files.isEmpty
                        ? EmptyState(theme: theme)
                        : viewMode == ViewMode.list
                        ? FileListView(
                          files: files,
                          onFileTap:
                              (file) => context.pushRoute(
                                FileViewerRoute(
                                  fileId: file.id,
                                  fileName: file.name,
                                ),
                              ),
                          onFileDelete: (file) => _confirmDelete(context, file),
                        )
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
    final l = context.locale;
    final bloc = context.read<FilesBloc>();

    final folderId = await showModalBottomSheet<String?>(
      context: context,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return _FolderPickerSheet(theme: theme, l: l);
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

class _FolderPickerSheet extends StatelessWidget {
  final ThemeData theme;
  final dynamic l;

  const _FolderPickerSheet({required this.theme, required this.l});

  @override
  Widget build(BuildContext context) {
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

  void _flatten(List<FolderItem> folders, List<_FlatFolder> result, int depth) {
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
