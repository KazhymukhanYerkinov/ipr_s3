import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image_outlined, size: 64, color: theme.colorScheme.error),
        const SizedBox(height: 12),
        Text('Failed to load image', style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
