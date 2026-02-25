import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/folders/domain/entities/folder_item.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/create_folder.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/delete_folder.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/move_file_to_folder.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/folders_behavior.dart';

part 'folders_bloc.freezed.dart';

// --- Events ---

sealed class FoldersEvent {}

final class FoldersLoadRequested extends FoldersEvent {}

final class FolderCreateRequested extends FoldersEvent {
  final String name;
  final String? parentId;
  FolderCreateRequested({required this.name, this.parentId});
}

final class FolderDeleteRequested extends FoldersEvent {
  final String folderId;
  FolderDeleteRequested(this.folderId);
}

final class FileMovedToFolder extends FoldersEvent {
  final String fileId;
  final String? folderId;
  FileMovedToFolder({required this.fileId, this.folderId});
}

// --- State ---

@freezed
class FoldersState with _$FoldersState {
  const factory FoldersState.initial() = FoldersInitial;
  const factory FoldersState.loading() = FoldersLoading;
  const factory FoldersState.loaded({
    required List<FolderItem> folders,
  }) = FoldersLoaded;
  const factory FoldersState.error({required String message}) = FoldersError;
}

// --- BLoC ---

@injectable
class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  final FoldersBehavior _foldersBehavior;
  final CreateFolderUseCase _createFolder;
  final DeleteFolderUseCase _deleteFolder;
  final MoveFileToFolderUseCase _moveFileToFolder;

  FoldersBloc(
    this._foldersBehavior,
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
    final result = await _foldersBehavior.getFolders();
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
