import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/use_cases/decrypt_file.dart';
import 'package:ipr_s3/features/files/domain/use_cases/get_file_by_id.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_event.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/bloc/file_viewer_state.dart';

@injectable
class FileViewerBloc extends Bloc<FileViewerEvent, FileViewerState> {
  final GetFileByIdUseCase _getFileById;
  final DecryptFileUseCase _decryptFile;

  FileViewerBloc(this._getFileById, this._decryptFile)
    : super(const FileViewerState.initial()) {
    on<FileViewerDecryptRequested>(_onDecrypt);
  }

  Future<void> _onDecrypt(
    FileViewerDecryptRequested event,
    Emitter<FileViewerState> emit,
  ) async {
    emit(const FileViewerState.loading());

    final entityResult = await _getFileById(event.fileId);
    if (entityResult.isError) {
      emit(FileViewerState.error(message: entityResult.failure!.message));
      return;
    }

    final result = await _decryptFile(event.fileId);
    if (result.isError) {
      emit(FileViewerState.error(message: result.failure!.message));
      return;
    }

    emit(
      FileViewerState.loaded(file: entityResult.value!, bytes: result.value!),
    );
  }
}
