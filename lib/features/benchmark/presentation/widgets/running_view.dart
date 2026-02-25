import 'package:flutter/material.dart';

class RunningView extends StatelessWidget {
  final String currentTask;
  final int completedSteps;
  final int totalSteps;
  final ThemeData theme;

  const RunningView({
    super.key,
    required this.currentTask,
    required this.completedSteps,
    required this.totalSteps,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalSteps > 0 ? completedSteps / totalSteps : 0.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(currentTask, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Step $completedSteps of $totalSteps',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
