import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

part 'stats_state.freezed.dart';

@freezed
sealed class StatsState with _$StatsState {
  const factory StatsState.initial() = StatsInitial;
  const factory StatsState.loading() = StatsLoading;
  const factory StatsState.loaded({
    required int totalFiles,
    required int totalSize,
    required Map<FileType, int> countByType,
    required Map<FileType, int> sizeByType,
    required List<SecureFileEntity> recentFiles,
    required List<SecureFileEntity> largestFiles,
  }) = StatsLoaded;
  const factory StatsState.error({required String message}) = StatsError;
}
