import 'package:flutter/material.dart';
import 'package:ipr_s3/features/benchmark/domain/models/benchmark_result.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/bar_row.dart';

class SpeedupCard extends StatelessWidget {
  final BenchmarkResult result;
  final ThemeData theme;

  const SpeedupCard({
    super.key,
    required this.result,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final maxMs = [result.dartMs, result.nativeMs, result.isolateMs]
        .reduce((a, b) => a > b ? a : b);
    final maxVal = maxMs > 0 ? maxMs.toDouble() : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${result.sizeMb} MB',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            BarRow(
              label: 'Dart',
              ms: result.dartMs,
              fraction: result.dartMs / maxVal,
              color: theme.colorScheme.error,
              theme: theme,
            ),
            const SizedBox(height: 8),
            BarRow(
              label: 'C (FFI)',
              ms: result.nativeMs,
              fraction: result.nativeMs / maxVal,
              color: theme.colorScheme.primary,
              theme: theme,
            ),
            const SizedBox(height: 8),
            BarRow(
              label: 'C + Isolate',
              ms: result.isolateMs,
              fraction: result.isolateMs / maxVal,
              color: theme.colorScheme.tertiary,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}
