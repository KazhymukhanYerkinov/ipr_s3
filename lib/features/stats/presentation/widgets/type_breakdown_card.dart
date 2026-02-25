import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/stats/presentation/utils/format_utils.dart';

class TypeBreakdownCard extends StatelessWidget {
  final Map<FileType, int> countByType;
  final Map<FileType, int> sizeByType;
  final ThemeData theme;

  const TypeBreakdownCard({
    super.key,
    required this.countByType,
    required this.sizeByType,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTypes =
        countByType.entries.toList()
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
                    Icon(
                      _iconForType(type),
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        type.name.toUpperCase(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text('$count files', style: theme.textTheme.bodySmall),
                    const SizedBox(width: 12),
                    Text(
                      formatSize(size),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
