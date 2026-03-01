import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';

class StorageSection extends StatelessWidget {
  final int? freeStorage;
  final int? totalStorage;
  final double? usagePercent;
  final ThemeData theme;

  const StorageSection({
    super.key,
    required this.freeStorage,
    required this.totalStorage,
    required this.usagePercent,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.storage_rounded,
              size: 28,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Storage', style: theme.textTheme.bodyLarge)),
            if (usagePercent != null)
              Text(
                '${(usagePercent! * 100).toStringAsFixed(0)}% used',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: usagePercent ?? 0,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              usagePercent != null && usagePercent! > 0.9
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          freeStorage != null && totalStorage != null
              ? '${formatSize(freeStorage!)} free of ${formatSize(totalStorage!)}'
              : 'Storage info unavailable',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
