import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';

class PdfPreview extends StatelessWidget {
  final Uint8List bytes;

  const PdfPreview({super.key, required this.bytes});

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
              color: theme.colorScheme.errorContainer.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.picture_as_pdf_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 20),
          Text('PDF Document', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            formatSize(bytes.length),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
