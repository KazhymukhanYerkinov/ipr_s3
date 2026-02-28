import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ipr_s3/features/benchmark/domain/models/benchmark_result.dart';

part 'benchmark_state.freezed.dart';

@freezed
sealed class BenchmarkState with _$BenchmarkState {
  const factory BenchmarkState.initial() = BenchmarkInitial;
  const factory BenchmarkState.running({
    required String currentTask,
    required int completedSteps,
    required int totalSteps,
  }) = BenchmarkRunning;
  const factory BenchmarkState.completed({
    required List<BenchmarkResult> results,
  }) = BenchmarkCompleted;
  const factory BenchmarkState.error({required String message}) =
      BenchmarkError;
}
