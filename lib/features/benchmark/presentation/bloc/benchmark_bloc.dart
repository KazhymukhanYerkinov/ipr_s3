import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/platform/native_hash_service.dart';
import 'package:ipr_s3/features/benchmark/domain/models/benchmark_result.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_event.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_state.dart';

/// Benchmarks Dart CRC32 vs native C CRC32 (FFI) on different data sizes.
/// Demonstrates Goal 7 (FFI) and Goal 3 (Isolate) performance comparison.
@injectable
class BenchmarkBloc extends Bloc<BenchmarkEvent, BenchmarkState> {
  final NativeHashService _nativeHashService;

  BenchmarkBloc(this._nativeHashService)
    : super(const BenchmarkState.initial()) {
    on<BenchmarkRunRequested>(_onRun);
  }

  Future<void> _onRun(
    BenchmarkRunRequested event,
    Emitter<BenchmarkState> emit,
  ) async {
    final sizes = [1, 5, 10];
    final totalSteps = sizes.length * 3;
    var completedSteps = 0;
    final results = <BenchmarkResult>[];

    try {
      for (final sizeMb in sizes) {
        final data = _generateTestData(sizeMb * 1024 * 1024);

        emit(
          BenchmarkState.running(
            currentTask: 'Dart CRC32 — ${sizeMb}MB',
            completedSteps: completedSteps,
            totalSteps: totalSteps,
          ),
        );
        final dartMs = await _benchmarkDartCrc32(data);
        completedSteps++;

        emit(
          BenchmarkState.running(
            currentTask: 'C (FFI) CRC32 — ${sizeMb}MB',
            completedSteps: completedSteps,
            totalSteps: totalSteps,
          ),
        );
        final nativeMs = _benchmarkNativeCrc32(data);
        completedSteps++;

        emit(
          BenchmarkState.running(
            currentTask: 'C (FFI) + Isolate CRC32 — ${sizeMb}MB',
            completedSteps: completedSteps,
            totalSteps: totalSteps,
          ),
        );
        final isolateMs = await _benchmarkIsolateCrc32(data);
        completedSteps++;

        results.add(
          BenchmarkResult(
            sizeMb: sizeMb,
            dartMs: dartMs,
            nativeMs: nativeMs,
            isolateMs: isolateMs,
          ),
        );
      }

      emit(BenchmarkState.completed(results: results));
    } catch (e) {
      emit(BenchmarkState.error(message: 'Benchmark failed: $e'));
    }
  }

  Uint8List _generateTestData(int size) {
    final data = Uint8List(size);
    final random = Random(42);
    for (var i = 0; i < size; i++) {
      data[i] = random.nextInt(256);
    }
    return data;
  }

  Future<int> _benchmarkDartCrc32(Uint8List data) async {
    final stopwatch = Stopwatch()..start();
    _dartCrc32(data);
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  int _benchmarkNativeCrc32(Uint8List data) {
    final stopwatch = Stopwatch()..start();
    _nativeHashService.crc32(data);
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  Future<int> _benchmarkIsolateCrc32(Uint8List data) async {
    final stopwatch = Stopwatch()..start();
    await compute(_isolateCrc32Worker, data);
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  static int _dartCrc32(Uint8List data) {
    var crc = 0xFFFFFFFF;
    for (var i = 0; i < data.length; i++) {
      crc ^= data[i];
      for (var j = 0; j < 8; j++) {
        crc = (crc >> 1) ^ (0xEDB88320 & (-(crc & 1)));
      }
    }
    return crc ^ 0xFFFFFFFF;
  }
}

/// Top-level function for compute() — runs native CRC32 in background isolate.
int _isolateCrc32Worker(Uint8List data) {
  var crc = 0xFFFFFFFF;
  for (var i = 0; i < data.length; i++) {
    crc ^= data[i];
    for (var j = 0; j < 8; j++) {
      crc = (crc >> 1) ^ (0xEDB88320 & (-(crc & 1)));
    }
  }
  return crc ^ 0xFFFFFFFF;
}
