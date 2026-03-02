import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/widgets/file_icon.dart';
import 'package:ipr_s3/features/folders/domain/models/file_item.dart';

class FileNodeTile extends StatelessWidget {
  final FileItem fileItem;
  final int depth;
  final void Function(SecureFileEntity file)? onTap;

  const FileNodeTile({
    super.key,
    required this.fileItem,
    required this.depth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entity = fileItem.entity;

    final (IconData icon, Color color) = FileIcon.resolve(entity.type, theme);

    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + depth * 24.0, right: 8),
      leading: Icon(icon, color: color),
      title: Text(entity.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(formatSize(entity.size), style: theme.textTheme.bodySmall),
      onTap: onTap != null ? () => onTap!(entity) : null,
    );
  }
}
