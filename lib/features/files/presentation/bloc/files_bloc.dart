import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/use_cases/delete_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/get_files.dart';
import 'package:ipr_s3/features/files/domain/use_cases/import_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/search_files.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_state.dart';

@injectable
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final GetFilesUseCase _getFilesUseCase;
  final ImportFileUseCase _importFileUseCase;
  final DeleteFileUseCase _deleteFileUseCase;
  final SearchFilesUseCase _searchFilesUseCase;

  FilesBloc(
    this._getFilesUseCase,
    this._importFileUseCase,
    this._deleteFileUseCase,
    this._searchFilesUseCase,
  ) : super(const FilesState.initial()) {
    on<FilesLoadRequested>(_onLoad);
    on<FileImportRequested>(_onImport);
    on<FileDeleteRequested>(_onDelete);
    on<FileSearchRequested>(_onSearch);
    on<FileSearchCleared>(_onSearchCleared);
    on<ViewModeToggled>(_onViewModeToggled);
  }

  ViewMode _currentViewMode = ViewMode.list;

  Future<void> _onLoad(
    FilesLoadRequested event,
    Emitter<FilesState> emit,
  ) async {
    emit(const FilesState.loading());
    final result = await _getFilesUseCase();
    result.fold(
      (failure) => emit(FilesState.error(message: failure.message)),
      (files) => emit(FilesState.loaded(
        files: files,
        viewMode: _currentViewMode,
      )),
    );
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

      final fileType = _resolveFileType(pickedFile.extension);
      final importResult = await _importFileUseCase(
        name: name,
        bytes: pickedFile.bytes!,
        type: fileType,
      );

      importResult.fold(
        (failure) => emit(FilesState.error(message: failure.message)),
        (_) => add(FilesLoadRequested()),
      );
    } catch (e) {
      emit(FilesState.error(message: 'Failed to pick file: $e'));
    }
  }

  Future<void> _onDelete(
    FileDeleteRequested event,
    Emitter<FilesState> emit,
  ) async {
    final result = await _deleteFileUseCase(event.file.id);
    result.fold(
      (failure) => emit(FilesState.error(message: failure.message)),
      (_) => add(FilesLoadRequested()),
    );
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
    result.fold(
      (failure) => emit(FilesState.error(message: failure.message)),
      (files) => emit(FilesState.loaded(
        files: files,
        viewMode: _currentViewMode,
        searchQuery: event.query,
      )),
    );
  }

  Future<void> _onSearchCleared(
    FileSearchCleared event,
    Emitter<FilesState> emit,
  ) async {
    add(FilesLoadRequested());
  }

  void _onViewModeToggled(
    ViewModeToggled event,
    Emitter<FilesState> emit,
  ) {
    _currentViewMode =
        _currentViewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;

    final currentState = state;
    if (currentState is FilesLoaded) {
      emit(currentState.copyWith(viewMode: _currentViewMode));
    }
  }

  FileType _resolveFileType(String? extension) {
    if (extension == null) return FileType.unknown;
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
        return FileType.image;
      case 'pdf':
        return FileType.pdf;
      case 'txt':
      case 'md':
      case 'json':
      case 'xml':
      case 'csv':
      case 'log':
        return FileType.text;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return FileType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'flac':
        return FileType.audio;
      default:
        return FileType.unknown;
    }
  }
}
