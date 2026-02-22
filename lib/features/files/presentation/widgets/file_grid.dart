import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

class FileGrid extends StatelessWidget {
  final List<SecureFileEntity> files;
  final ValueChanged<SecureFileEntity> onFileTap;
  final ValueChanged<SecureFileEntity> onFileDelete;

  const FileGrid({
    super.key,
    required this.files,
    required this.onFileTap,
    required this.onFileDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: files.length,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final file = files[index];
        return RepaintBoundary(
          child: _GridCard(
            file: file,
            onTap: () => onFileTap(file),
            onDelete: () => onFileDelete(file),
          ),
        );
      },
    );
  }
}

class _GridCard extends StatelessWidget {
  final SecureFileEntity file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _GridCard({
    required this.file,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, Color color) = _iconForType(file.type, theme);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: color.withAlpha(15),
                child: Center(
                  child: Icon(icon, size: 48, color: color),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: theme.textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatSize(file.size),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _iconForType(FileType type, ThemeData theme) {
    return switch (type) {
      FileType.image => (Icons.image_outlined, theme.colorScheme.primary),
      FileType.pdf => (Icons.picture_as_pdf_rounded, theme.colorScheme.error),
      FileType.text => (Icons.description_outlined, theme.colorScheme.tertiary),
      FileType.video => (Icons.videocam_outlined, Colors.deepPurple),
      FileType.audio => (Icons.audiotrack_outlined, Colors.orange),
      FileType.unknown => (Icons.insert_drive_file_outlined, theme.colorScheme.onSurfaceVariant),
    };
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
