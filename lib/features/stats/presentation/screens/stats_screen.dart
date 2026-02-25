import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_bloc.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_event.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_state.dart';
import 'package:ipr_s3/features/stats/presentation/widgets/file_list_card.dart';
import 'package:ipr_s3/features/stats/presentation/widgets/summary_card.dart';
import 'package:ipr_s3/features/stats/presentation/widgets/type_breakdown_card.dart';

@RoutePage()
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StatsBloc>()..add(StatsLoadRequested()),
      child: const _StatsView(),
    );
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: BlocBuilder<StatsBloc, StatsState>(
        builder: (context, state) {
          return switch (state) {
            StatsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            StatsLoaded(
              :final totalFiles,
              :final totalSize,
              :final countByType,
              :final sizeByType,
              :final recentFiles,
              :final largestFiles,
            ) =>
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SummaryCard(
                    totalFiles: totalFiles,
                    totalSize: totalSize,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  TypeBreakdownCard(
                    countByType: countByType,
                    sizeByType: sizeByType,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  FileListCard(
                    title: 'Recent Files',
                    icon: Icons.access_time_rounded,
                    files: recentFiles,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  FileListCard(
                    title: 'Largest Files',
                    icon: Icons.storage_rounded,
                    files: largestFiles,
                    theme: theme,
                  ),
                ],
              ),
            StatsError(:final message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48,
                        color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(message),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => context
                          .read<StatsBloc>()
                          .add(StatsLoadRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
