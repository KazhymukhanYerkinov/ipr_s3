import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/get_files_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_event.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_state.dart';

/// Демонстрация Цели 6: map, where, fold, sort+take
/// на реальных данных для экрана статистики.
@injectable
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetFilesBehavior _getFilesBehavior;

  StatsBloc(this._getFilesBehavior) : super(const StatsState.initial()) {
    on<StatsLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    StatsLoadRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsState.loading());

    final result = await _getFilesBehavior.getFiles();

    result.fold(
      (failure) => emit(StatsState.error(message: failure.message)),
      (files) {
        final totalSize = files.fold<int>(0, (sum, f) => sum + f.size);

        final countByType = <FileType, int>{};
        final sizeByType = <FileType, int>{};
        for (final file in files) {
          countByType[file.type] = (countByType[file.type] ?? 0) + 1;
          sizeByType[file.type] = (sizeByType[file.type] ?? 0) + file.size;
        }

        final recentFiles = [...files]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final top5Recent = recentFiles.take(5).toList();

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
