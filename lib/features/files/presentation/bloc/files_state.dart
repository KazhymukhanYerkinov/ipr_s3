import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

part 'files_state.freezed.dart';

enum ViewMode { list, grid }

@freezed
class FilesState with _$FilesState {
  const factory FilesState.initial() = FilesInitial;
  const factory FilesState.loading() = FilesLoading;
  const factory FilesState.loaded({
    required List<SecureFileEntity> files,
    @Default(ViewMode.list) ViewMode viewMode,
    @Default('') String searchQuery,
  }) = FilesLoaded;
  const factory FilesState.importing({required String fileName}) = FilesImporting;
  const factory FilesState.error({required String message}) = FilesError;
}
