import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_event.dart';

class BenchmarkErrorView extends StatelessWidget {
  final String message;
  final ThemeData theme;

  const BenchmarkErrorView({
    super.key,
    required this.message,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48,
                color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () =>
                  context.read<BenchmarkBloc>().add(BenchmarkRunRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
