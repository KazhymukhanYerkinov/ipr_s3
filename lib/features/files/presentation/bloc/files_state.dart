import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';

part 'files_state.freezed.dart';

enum ViewMode { list, grid }

@freezed
sealed class FilesState with _$FilesState {
  const factory FilesState.initial() = FilesInitial;
  const factory FilesState.loading() = FilesLoading;
  const factory FilesState.loaded({
    required List<SecureFileEntity> files,
    @Default(ViewMode.list) ViewMode viewMode,
    @Default('') String searchQuery,
    SortStrategy? sortStrategy,
  }) = FilesLoaded;
  const factory FilesState.importing({required String fileName}) =
      FilesImporting;
  const factory FilesState.error({required String message}) = FilesError;
}
