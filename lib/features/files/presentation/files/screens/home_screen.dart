import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart' as picker;
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
import 'package:ipr_s3/features/files/presentation/files/bloc/files_bloc.dart';
import 'package:ipr_s3/features/files/presentation/files/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/files/bloc/files_state.dart';
import 'package:ipr_s3/features/files/presentation/files/bloc/thumbnail_cubit.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/empty_state.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/file_grid.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/folder_picker_sheet.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/search_bar_widget.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/sort_dropdown.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/get_folders.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<FilesBloc>()..add(FilesLoadRequested()),
        ),
        BlocProvider(create: (_) => getIt<ThumbnailCubit>()),
      ],
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
          BlocSelector<FilesBloc, FilesState, ({bool canUndo, bool canRedo})>(
            selector:
                (state) => switch (state) {
                  FilesLoaded(:final canUndo, :final canRedo) => (
                    canUndo: canUndo,
                    canRedo: canRedo,
                  ),
                  _ => (canUndo: false, canRedo: false),
                },
            builder: (context, record) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.undo_rounded),
                    tooltip: l.undo,
                    onPressed:
                        record.canUndo
                            ? () {
                              final bloc = context.read<FilesBloc>();
                              bloc.add(UndoRequested());
                              _showUndoneSnackBar(context, bloc);
                            }
                            : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo_rounded),
                    tooltip: l.redo,
                    onPressed:
                        record.canRedo
                            ? () {
                              final bloc = context.read<FilesBloc>();
                              bloc.add(RedoRequested());
                              _showRedoneSnackBar(context, bloc);
                            }
                            : null,
                  ),
                ],
              );
            },
          ),
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
        return FolderPickerSheet(
          theme: theme,
          onLoadFolders: () async {
            final result = await getIt<GetFoldersUseCase>()();
            return result.value ?? [];
          },
        );
      },
    );

    if (folderId == null) return;

    final result = await picker.FilePicker.platform.pickFiles(
      type: picker.FileType.any,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;
    final pickedFile = result.files.first;
    if (pickedFile.bytes == null) return;

    bloc.add(
      FileImportRequested(
        name: pickedFile.name,
        bytes: pickedFile.bytes!,
        extension: pickedFile.extension,
        folderId: folderId.isEmpty ? null : folderId,
      ),
    );
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
    _showDeletedSnackBar(context, bloc, file);
  }

  void _showDeletedSnackBar(
    BuildContext context,
    FilesBloc bloc,
    SecureFileEntity file,
  ) {
    final l = context.locale;
    context.showFloatingSnackBar(
      l.fileDeleted(file.name),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.undo,
        onPressed: () {
          bloc.add(UndoRequested());
          if (context.mounted) _showUndoneSnackBar(context, bloc);
        },
      ),
    );
  }

  void _showUndoneSnackBar(BuildContext context, FilesBloc bloc) {
    final l = context.locale;
    context.showFloatingSnackBar(
      l.actionUndone,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.redo,
        onPressed: () {
          bloc.add(RedoRequested());
          if (context.mounted) _showRedoneSnackBar(context, bloc);
        },
      ),
    );
  }

  void _showRedoneSnackBar(BuildContext context, FilesBloc bloc) {
    final l = context.locale;
    context.showFloatingSnackBar(
      l.actionRedone,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l.undo,
        onPressed: () {
          bloc.add(UndoRequested());
          if (context.mounted) _showUndoneSnackBar(context, bloc);
        },
      ),
    );
  }
}
