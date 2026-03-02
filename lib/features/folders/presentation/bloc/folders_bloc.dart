import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/create_folder.dart';
import 'package:ipr_s3/features/folders/domain/use_cases/delete_folder.dart';
import 'package:ipr_s3/features/folders/domain/behaviors/get_folders_behavior.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_event.dart';
import 'package:ipr_s3/features/folders/presentation/bloc/folders_state.dart';

@injectable
class FoldersBloc extends Bloc<FoldersEvent, FoldersState> {
  final GetFoldersBehavior _getFoldersBehavior;
  final CreateFolderUseCase _createFolder;
  final DeleteFolderUseCase _deleteFolder;

  FoldersBloc(this._getFoldersBehavior, this._createFolder, this._deleteFolder)
    : super(const FoldersState.initial()) {
    _setupHandlers();
  }

  void _setupHandlers() {
    on<FoldersLoadRequested>(_onLoad);
    on<FolderCreateRequested>(_onCreate);
    on<FolderDeleteRequested>(_onDelete);
  }

  Future<void> _onLoad(
    FoldersLoadRequested event,
    Emitter<FoldersState> emit,
  ) async {
    emit(const FoldersState.loading());
    final result = await _getFoldersBehavior.getFolders();
    result.when(
      success: (folders) => emit(FoldersState.loaded(folders: folders)),
      error: (f) => emit(FoldersState.error(message: f.message)),
    );
  }

  Future<void> _onCreate(
    FolderCreateRequested event,
    Emitter<FoldersState> emit,
  ) async {
    final result = await _createFolder(
      CreateFolderParams(name: event.name, parentId: event.parentId),
    );
    result.when(
      success: (_) => add(FoldersLoadRequested()),
      error: (f) => emit(FoldersState.error(message: f.message)),
    );
  }

  Future<void> _onDelete(
    FolderDeleteRequested event,
    Emitter<FoldersState> emit,
  ) async {
    final result = await _deleteFolder(event.folderId);
    result.when(
      success: (_) => add(FoldersLoadRequested()),
      error: (f) => emit(FoldersState.error(message: f.message)),
    );
  }
}
