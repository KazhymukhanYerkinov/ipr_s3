import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

class UnknownPreview extends StatelessWidget {
  final SecureFileEntity file;

  const UnknownPreview({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(100),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insert_drive_file_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(file.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${(file.size / 1024).toStringAsFixed(1)} KB',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preview not available for this file type',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
