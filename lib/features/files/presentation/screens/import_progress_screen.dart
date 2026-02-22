import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/files/data/services/encryption_queue.dart';

@RoutePage()
class ImportProgressScreen extends StatefulWidget {
  const ImportProgressScreen({super.key});

  @override
  State<ImportProgressScreen> createState() => _ImportProgressScreenState();
}

class _ImportProgressScreenState extends State<ImportProgressScreen> {
  late final EncryptionQueue _queue;
  StreamSubscription<QueueProgress>? _subscription;
  QueueProgress? _currentProgress;

  @override
  void initState() {
    super.initState();
    _queue = getIt<EncryptionQueue>();
    _subscription = _queue.progress.listen((progress) {
      if (mounted) {
        setState(() => _currentProgress = progress);
      }
      if (progress.isComplete && mounted) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) context.maybePop();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _currentProgress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importing Files'),
      ),
      body: Center(
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
                        value: progress?.progress,
                        strokeWidth: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    if (progress != null)
                      Text(
                        '${(progress.progress * 100).toInt()}%',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (progress != null) ...[
                Text(
                  progress.fileName,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.completedCount} of ${progress.totalCount} files',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                if (progress.isComplete)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'All files encrypted!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ] else ...[
                Text(
                  'Preparing...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
