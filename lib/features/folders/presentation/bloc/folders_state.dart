import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/folders/domain/models/folder_item.dart';

part 'folders_state.freezed.dart';

@freezed
sealed class FoldersState with _$FoldersState {
  const factory FoldersState.initial() = FoldersInitial;
  const factory FoldersState.loading() = FoldersLoading;
  const factory FoldersState.loaded({required List<FolderItem> folders}) =
      FoldersLoaded;
  const factory FoldersState.error({required String message}) = FoldersError;
}
