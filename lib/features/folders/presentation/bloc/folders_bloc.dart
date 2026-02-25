import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/create_folder.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/delete_folder.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/move_file_to_folder.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_event.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_state.dart';

@injectable
class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  final GetFoldersBehavior _getFoldersBehavior;
  final CreateFolderUseCase _createFolder;
  final DeleteFolderUseCase _deleteFolder;
  final MoveFileToFolderUseCase _moveFileToFolder;

  FoldersBloc(
    this._getFoldersBehavior,
    this._createFolder,
    this._deleteFolder,
    this._moveFileToFolder,
  ) : super(const FoldersState.initial()) {
    on<FoldersLoadRequested>(_onLoad);
    on<FolderCreateRequested>(_onCreate);
    on<FolderDeleteRequested>(_onDelete);
    on<FileMovedToFolder>(_onMoveFile);
  }

  Future<void> _onLoad(
    FoldersLoadRequested event,
    Emitter<FoldersState> emit,
  ) async {
    emit(const FoldersState.loading());
    final result = await _getFoldersBehavior.getFolders();
    result.fold(
      (failure) => emit(FoldersState.error(message: failure.message)),
      (folders) => emit(FoldersState.loaded(folders: folders)),
    );
  }

  Future<void> _onCreate(
    FolderCreateRequested event,
    Emitter<FoldersState> emit,
  ) async {
    final result = await _createFolder(
      name: event.name,
      parentId: event.parentId,
    );
    result.fold(
      (failure) => emit(FoldersState.error(message: failure.message)),
      (_) => add(FoldersLoadRequested()),
    );
  }

  Future<void> _onDelete(
    FolderDeleteRequested event,
    Emitter<FoldersState> emit,
  ) async {
    final result = await _deleteFolder(event.folderId);
    result.fold(
      (failure) => emit(FoldersState.error(message: failure.message)),
      (_) => add(FoldersLoadRequested()),
    );
  }

  Future<void> _onMoveFile(
    FileMovedToFolder event,
    Emitter<FoldersState> emit,
  ) async {
    final result = await _moveFileToFolder(
      fileId: event.fileId,
      folderId: event.folderId,
    );
    result.fold(
      (failure) => emit(FoldersState.error(message: failure.message)),
      (_) => add(FoldersLoadRequested()),
    );
  }
}
