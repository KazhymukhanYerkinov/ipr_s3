import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';

class FileListCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<SecureFileEntity> files;
  final ThemeData theme;

  const FileListCard({
    super.key,
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
              ...files.map(
                (file) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          file.name,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        formatSize(file.size),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
