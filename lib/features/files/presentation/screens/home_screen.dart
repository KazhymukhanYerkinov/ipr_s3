import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/core/router/app_router.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_state.dart';
import 'package:ipr_s3/features/files/presentation/widgets/empty_state.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_grid.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_list_view.dart';
import 'package:ipr_s3/features/files/presentation/widgets/search_bar_widget.dart';
import 'package:ipr_s3/features/files/presentation/widgets/sort_dropdown.dart';

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
            selector: (state) =>
                state is FilesLoaded ? state.viewMode : null,
            builder: (context, viewMode) {
              return IconButton(
                onPressed: () =>
                    context.read<FilesBloc>().add(ViewModeToggled()),
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
            itemBuilder: (_) => [
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
            onSearch: (query) =>
                context.read<FilesBloc>().add(FileSearchRequested(query)),
            onClear: () => context.read<FilesBloc>().add(FileSearchCleared()),
          ),
          Expanded(
            child: BlocConsumer<FilesBloc, FilesState>(
              listener: (context, state) {
                if (state is FilesError) {
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
                  FilesLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  FilesImporting(:final fileName) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            l.encryptingFile(fileName),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  FilesLoaded(:final files, :final viewMode) =>
                    files.isEmpty
                        ? EmptyState(theme: theme)
                        : viewMode == ViewMode.list
                            ? FileListView(
                                files: files,
                                onFileTap: (file) => context.pushRoute(
                                  FileViewerRoute(fileId: file.id, fileName: file.name),
                                ),
                                onFileDelete: (file) => _confirmDelete(
                                  context,
                                  file,
                                ),
                              )
                            : FileGrid(
                                files: files,
                                onFileTap: (file) => context.pushRoute(
                                  FileViewerRoute(fileId: file.id, fileName: file.name),
                                ),
                                onFileDelete: (file) => _confirmDelete(
                                  context,
                                  file,
                                ),
                              ),
                  FilesError() => Center(
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
                                .read<FilesBloc>()
                                .add(FilesLoadRequested()),
                            child: Text(l.retry),
                          ),
                        ],
                      ),
                    ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<FilesBloc>().add(FileImportRequested()),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _confirmDelete(BuildContext context, SecureFileEntity file) {
    final l = context.locale;
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(l.deleteFileTitle),
          content: Text(
            l.deleteFileContent(file.name),
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
                context.read<FilesBloc>().add(FileDeleteRequested(file));
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
