import 'package:flutter/material.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';

class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? retryLabel;

  const ErrorStateView({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(retryLabel ?? context.locale.retry),
            ),
          ],
        ),
      ),
    );
  }
}
