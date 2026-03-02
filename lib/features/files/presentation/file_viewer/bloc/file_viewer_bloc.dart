import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_event.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_state.dart';

@injectable
class FileViewerBloc extends Bloc<FileViewerEvent, FileViewerState> {
  final FilesLocalSource _localSource;
  final DecryptFileUseCase _decryptFile;

  FileViewerBloc(this._localSource, this._decryptFile)
    : super(const FileViewerState.initial()) {
    on<FileViewerDecryptRequested>(_onDecrypt);
  }

  Future<void> _onDecrypt(
    FileViewerDecryptRequested event,
    Emitter<FileViewerState> emit,
  ) async {
    emit(const FileViewerState.loading());

    final entity = await _localSource.getById(event.fileId);
    if (entity == null) {
      emit(const FileViewerState.error(message: 'File not found'));
      return;
    }

    final result = await _decryptFile(event.fileId);
    final failure = result.failure;

    if (failure != null) {
      emit(FileViewerState.error(message: failure.message));
      return;
    }

    emit(FileViewerState.loaded(file: entity, bytes: result.value!));
  }
}
