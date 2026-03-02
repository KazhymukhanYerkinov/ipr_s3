import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/commands/command_manager.dart';
import 'package:ipr_s3/features/files/domain/commands/delete_file_command.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_by_date.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart';
import 'package:ipr_s3/features/files/domain/use_cases/import_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/search_files.dart';
import 'package:ipr_s3/features/files/domain/utils/file_type_resolver.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_state.dart';

@injectable
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final GetFilesUseCase _getFilesUseCase;
  final ImportFileUseCase _importFileUseCase;
  final SearchFilesUseCase _searchFilesUseCase;
  final CommandManager _commandManager;
  final FilesLocalSource _localSource;

  FilesBloc(
    this._getFilesUseCase,
    this._importFileUseCase,
    this._searchFilesUseCase,
    this._commandManager,
    this._localSource,
  ) : super(const FilesState.initial()) {
    _setupHandlers();
  }

  SortStrategy _currentSortStrategy = SortByDate();

  void _setupHandlers() {
    on<FilesLoadRequested>(_onLoad);
    on<FileImportRequested>(_onImport);
    on<FileDeleteRequested>(_onDelete);
    on<FileSearchRequested>(_onSearch);
    on<FileSearchCleared>(_onSearchCleared);
    on<SortStrategyChanged>(_onSortStrategyChanged);
    on<UndoRequested>(_onUndo);
    on<RedoRequested>(_onRedo);
  }

  Future<void> _onLoad(
    FilesLoadRequested event,
    Emitter<FilesState> emit,
  ) async {
    emit(const FilesState.loading());
    final result = await _getFilesUseCase();
    final failure = result.failure;

    if (failure != null) {
      emit(FilesState.error(message: failure.message));
      return;
    }

    final files = result.value ?? [];
    final sorted = _currentSortStrategy.sort(files);
    emit(FilesState.loaded(files: sorted, sortStrategy: _currentSortStrategy));
  }

  Future<void> _onImport(
    FileImportRequested event,
    Emitter<FilesState> emit,
  ) async {
    try {
      final result = await picker.FilePicker.platform.pickFiles(
        type: picker.FileType.any,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;
      if (pickedFile.bytes == null) return;

      final name = pickedFile.name;
      emit(FilesState.importing(fileName: name));

      final fileType = FileTypeResolver.fromExtension(pickedFile.extension);
      final importResult = await _importFileUseCase(
        ImportFileParams(
          name: name,
          bytes: pickedFile.bytes!,
          type: fileType,
          folderId: event.folderId,
        ),
      );

      final failure = importResult.failure;
      if (failure != null) {
        emit(FilesState.error(message: failure.message));
        return;
      }

      await _silentReload(emit);
    } catch (e) {
      emit(FilesState.error(message: 'Failed to pick file: $e'));
    }
  }

  Future<void> _onDelete(
    FileDeleteRequested event,
    Emitter<FilesState> emit,
  ) async {
    final currentState = state;
    if (currentState is FilesLoaded) {
      final updated =
          currentState.files.where((f) => f.id != event.file.id).toList();
      emit(currentState.copyWith(files: updated));
    }

    try {
      final command = DeleteFileCommand(_localSource, event.file);
      await _commandManager.execute(command);
    } catch (e) {
      await _silentReload(emit);
    }
  }

  Future<void> _onUndo(UndoRequested event, Emitter<FilesState> emit) async {
    if (!_commandManager.canUndo) return;
    await _runCommand(emit, () => _commandManager.undo(), 'Failed to undo');
  }

  Future<void> _onRedo(RedoRequested event, Emitter<FilesState> emit) async {
    if (!_commandManager.canRedo) return;
    await _runCommand(emit, () => _commandManager.redo(), 'Failed to redo');
  }

  Future<void> _runCommand(
    Emitter<FilesState> emit,
    Future<void> Function() action,
    String errorMessage,
  ) async {
    try {
      await action();
      await _silentReload(emit);
    } catch (e) {
      emit(FilesState.error(message: errorMessage));
    }
  }

  Future<void> _silentReload(Emitter<FilesState> emit) async {
    final result = await _getFilesUseCase();
    final failure = result.failure;

    if (failure != null) {
      emit(FilesState.error(message: failure.message));
      return;
    }

    final files = result.value ?? [];
    final sorted = _currentSortStrategy.sort(files);
    emit(FilesState.loaded(files: sorted, sortStrategy: _currentSortStrategy));
  }

  Future<void> _onSearch(
    FileSearchRequested event,
    Emitter<FilesState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(FilesLoadRequested());
      return;
    }

    final result = await _searchFilesUseCase(event.query);
    final failure = result.failure;

    if (failure != null) {
      emit(FilesState.error(message: failure.message));
      return;
    }

    final files = result.value ?? [];
    final sorted = _currentSortStrategy.sort(files);
    emit(
      FilesState.loaded(
        files: sorted,
        searchQuery: event.query,
        sortStrategy: _currentSortStrategy,
      ),
    );
  }

  Future<void> _onSearchCleared(
    FileSearchCleared event,
    Emitter<FilesState> emit,
  ) async {
    add(FilesLoadRequested());
  }

  void _onSortStrategyChanged(
    SortStrategyChanged event,
    Emitter<FilesState> emit,
  ) {
    _currentSortStrategy = event.strategy;

    final currentState = state;
    if (currentState is FilesLoaded) {
      final sorted = _currentSortStrategy.sort(currentState.files);
      emit(
        currentState.copyWith(
          files: sorted,
          sortStrategy: _currentSortStrategy,
        ),
      );
    }
  }
}
