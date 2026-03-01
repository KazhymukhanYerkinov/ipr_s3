import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class FileIcon extends StatelessWidget {
  final FileType type;
  final double size;

  const FileIcon({super.key, required this.type, this.size = 24});

  static (IconData, Color) resolve(FileType type, ThemeData theme) {
    return switch (type) {
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, Color color) = resolve(type, theme);
    final containerSize = size + 20;

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}
