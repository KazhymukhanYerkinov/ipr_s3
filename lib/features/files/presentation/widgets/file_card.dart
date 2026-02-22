import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

class FileCard extends StatelessWidget {
  final SecureFileEntity file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FileCard({
    super.key,
    required this.file,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _FileIcon(type: file.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatSize(file.size)} • ${_formatDate(file.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}

class _FileIcon extends StatelessWidget {
  final FileType type;

  const _FileIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, Color color) = switch (type) {
      FileType.image => (Icons.image_outlined, theme.colorScheme.primary),
      FileType.pdf => (Icons.picture_as_pdf_rounded, theme.colorScheme.error),
      FileType.text => (Icons.description_outlined, theme.colorScheme.tertiary),
      FileType.video => (Icons.videocam_outlined, Colors.deepPurple),
      FileType.audio => (Icons.audiotrack_outlined, Colors.orange),
      FileType.unknown => (Icons.insert_drive_file_outlined, theme.colorScheme.onSurfaceVariant),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
