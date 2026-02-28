import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_bloc.dart';
import 'package:ipr_s3/features/benchmark/presentation/bloc/benchmark_state.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/benchmark_error_view.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/initial_view.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/results_view.dart';
import 'package:ipr_s3/features/benchmark/presentation/widgets/running_view.dart';

@RoutePage()
class BenchmarkScreen extends StatelessWidget {
  const BenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BenchmarkBloc>(),
      child: const _BenchmarkView(),
    );
  }
}

class _BenchmarkView extends StatelessWidget {
  const _BenchmarkView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.locale.benchmarkTitle)),
      body: BlocBuilder<BenchmarkBloc, BenchmarkState>(
        builder: (context, state) {
          return switch (state) {
            BenchmarkInitial() => InitialView(theme: theme),
            BenchmarkRunning(
              :final currentTask,
              :final completedSteps,
              :final totalSteps,
            ) =>
              RunningView(
                currentTask: currentTask,
                completedSteps: completedSteps,
                totalSteps: totalSteps,
                theme: theme,
              ),
            BenchmarkCompleted(:final results) => ResultsView(
              results: results,
              theme: theme,
            ),
            BenchmarkError(:final message) => BenchmarkErrorView(
              message: message,
              theme: theme,
            ),
          };
        },
      ),
    );
  }
}
