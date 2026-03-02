import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/file_icon.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/file_thumbnail.dart';

class GridCard extends StatelessWidget {
  final SecureFileEntity file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GridCard({
    super.key,
    required this.file,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(child: _buildPreview()),
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
                          formatSize(file.size),
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

  Widget _buildPreview() {
    if (file.thumbnailPath != null) {
      return FileThumbnail(
        thumbnailPath: file.thumbnailPath!,
        fileType: file.type,
        iconSize: 48,
      );
    }
    return Center(child: FileIcon(type: file.type, size: 48));
  }
}
