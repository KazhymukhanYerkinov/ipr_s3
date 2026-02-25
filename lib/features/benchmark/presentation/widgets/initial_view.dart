import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_event.dart';

class InitialView extends StatelessWidget {
  final ThemeData theme;

  const InitialView({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.speed_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'CRC32 Performance Benchmark',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Compares pure Dart CRC32 implementation against native C via FFI '
              'on 1 MB, 5 MB, and 10 MB of random data.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed:
                  () => context.read<BenchmarkBloc>().add(
                    BenchmarkRunRequested(),
                  ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run Benchmark'),
            ),
          ],
        ),
      ),
    );
  }
}
