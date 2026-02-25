import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/stats/presentation/bloc/stats_bloc.dart';

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
                  _SummaryCard(
                    totalFiles: totalFiles,
                    totalSize: totalSize,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _TypeBreakdownCard(
                    countByType: countByType,
                    sizeByType: sizeByType,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _FileListCard(
                    title: 'Recent Files',
                    icon: Icons.access_time_rounded,
                    files: recentFiles,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _FileListCard(
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

class _SummaryCard extends StatelessWidget {
  final int totalFiles;
  final int totalSize;
  final ThemeData theme;

  const _SummaryCard({
    required this.totalFiles,
    required this.totalSize,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Total Files',
                value: '$totalFiles',
                icon: Icons.insert_drive_file_outlined,
                theme: theme,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: _StatItem(
                label: 'Total Size',
                value: _formatSize(totalSize),
                icon: Icons.storage_outlined,
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TypeBreakdownCard extends StatelessWidget {
  final Map<FileType, int> countByType;
  final Map<FileType, int> sizeByType;
  final ThemeData theme;

  const _TypeBreakdownCard({
    required this.countByType,
    required this.sizeByType,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTypes = countByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By Type', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...sortedTypes.map((entry) {
              final type = entry.key;
              final count = entry.value;
              final size = sizeByType[type] ?? 0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(_iconForType(type), size: 20,
                        color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(type.name.toUpperCase(),
                          style: theme.textTheme.bodyMedium),
                    ),
                    Text('$count files',
                        style: theme.textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Text(_formatSize(size),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(FileType type) {
    return switch (type) {
      FileType.image => Icons.image_outlined,
      FileType.pdf => Icons.picture_as_pdf_outlined,
      FileType.text => Icons.text_snippet_outlined,
      FileType.video => Icons.videocam_outlined,
      FileType.audio => Icons.audiotrack_outlined,
      FileType.unknown => Icons.insert_drive_file_outlined,
    };
  }
}

class _FileListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SecureFileEntity> files;
  final ThemeData theme;

  const _FileListCard({
    required this.title,
    required this.icon,
    required this.files,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            if (files.isEmpty)
              Text('No files', style: theme.textTheme.bodySmall)
            else
              ...files.map((file) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(file.name,
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(_formatSize(file.size),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}
