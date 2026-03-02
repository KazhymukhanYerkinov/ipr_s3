import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

part 'file_viewer_state.freezed.dart';

@freezed
sealed class FileViewerState with _$FileViewerState {
  const factory FileViewerState.initial() = FileViewerInitial;
  const factory FileViewerState.loading() = FileViewerLoading;
  const factory FileViewerState.loaded({
    required SecureFileEntity file,
    required Uint8List bytes,
  }) = FileViewerLoaded;
  const factory FileViewerState.error({required String message}) =
      FileViewerError;
}
