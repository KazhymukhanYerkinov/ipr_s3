import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/features/benchmark/domain/models/benchmark_result.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_event.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/results_table.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/speedup_card.dart';

class ResultsView extends StatelessWidget {
  final List<BenchmarkResult> results;
  final ThemeData theme;

  const ResultsView({super.key, required this.results, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.table_chart_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text('CRC32 Results', style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 16),
                ResultsTable(results: results, theme: theme),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...results.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SpeedupCard(result: r, theme: theme),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.tonal(
            onPressed:
                () =>
                    context.read<BenchmarkBloc>().add(BenchmarkRunRequested()),
            child: const Text('Run Again'),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
