import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class FileIcon extends StatelessWidget {
  final FileType type;

  const FileIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, Color color) = switch (type) {
      FileType.image => (Icons.image_outlined, theme.colorScheme.primary),
      FileType.pdf => (Icons.picture_as_pdf_rounded, theme.colorScheme.error),
      FileType.text => (Icons.description_outlined, theme.colorScheme.tertiary),
      FileType.video => (Icons.videocam_outlined, Colors.deepPurple),
      FileType.audio => (Icons.audiotrack_outlined, Colors.orange),
      FileType.unknown => (
        Icons.insert_drive_file_outlined,
        theme.colorScheme.onSurfaceVariant,
      ),
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
