import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/presentation/file_viewer/widgets/previews/error_placeholder.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List bytes;

  const ImagePreview({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width.toInt();

    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.memory(
          bytes,
          fit: BoxFit.contain,
          cacheWidth: screenWidth * 2,
          errorBuilder: (_, __, ___) => const ErrorPlaceholder(),
        ),
      ),
    );
  }
}
