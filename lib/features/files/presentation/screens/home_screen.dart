import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/router/app_router.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_state.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_grid.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_list_view.dart';
import 'package:ipr_s3/features/files/presentation/widgets/search_bar_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Secure'),
        actions: [
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
                            'Encrypting $fileName...',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  FilesLoaded(:final files, :final viewMode) =>
                    files.isEmpty
                        ? _EmptyState(theme: theme)
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
                          Text('Something went wrong',
                              style: theme.textTheme.bodyLarge),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: () => context
                                .read<FilesBloc>()
                                .add(FilesLoadRequested()),
                            child: const Text('Retry'),
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

  void _confirmDelete(BuildContext context, dynamic file) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: const Text('Delete file?'),
          content: Text(
            'This will permanently delete "${file.name}".',
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
                context.read<FilesBloc>().add(FileDeleteRequested(file));
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

class _EmptyState extends StatelessWidget {
  final ThemeData theme;

  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(60),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              size: 56,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No files yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to import and encrypt your first file',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
