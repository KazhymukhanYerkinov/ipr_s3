import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

part 'stats_bloc.freezed.dart';

// --- Events ---

sealed class StatsEvent {}

final class StatsLoadRequested extends StatsEvent {}

// --- State ---

@freezed
class StatsState with _$StatsState {
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

// --- BLoC ---

/// Демонстрация Цели 6: map, where, fold, sort+take
/// на реальных данных для экрана статистики.
@injectable
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final FilesBehavior _filesBehavior;

  StatsBloc(this._filesBehavior) : super(const StatsState.initial()) {
    on<StatsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    StatsLoadRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsState.loading());

    final result = await _filesBehavior.getFiles();

    result.fold(
      (failure) => emit(StatsState.error(message: failure.message)),
      (files) {
        // fold — общий размер всех файлов
        final totalSize = files.fold<int>(0, (sum, f) => sum + f.size);

        // groupBy по типу — количество файлов каждого типа
        final countByType = <FileType, int>{};
        final sizeByType = <FileType, int>{};
        for (final file in files) {
          countByType[file.type] = (countByType[file.type] ?? 0) + 1;
          sizeByType[file.type] = (sizeByType[file.type] ?? 0) + file.size;
        }

        // where + sort + take — 5 самых последних файлов
        final recentFiles = [...files]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final top5Recent = recentFiles.take(5).toList();

        // sort + take — 5 самых больших файлов
        final largestFiles = [...files]
          ..sort((a, b) => b.size.compareTo(a.size));
        final top5Largest = largestFiles.take(5).toList();

        emit(StatsState.loaded(
          totalFiles: files.length,
          totalSize: totalSize,
          countByType: countByType,
          sizeByType: sizeByType,
          recentFiles: top5Recent,
          largestFiles: top5Largest,
        ));
      },
    );
  }
}
