import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class TextPreview extends StatelessWidget {
  final Uint8List bytes;

  const TextPreview({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = utf8.decode(bytes, allowMalformed: true);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SelectableText(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: 'monospace',
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
