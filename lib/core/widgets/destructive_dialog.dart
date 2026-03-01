import 'package:flutter/material.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';

Future<bool> showDestructiveDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  final theme = Theme.of(context);
  final l = context.locale;

  final result = await showDialog<bool>(
    context: context,
    builder:
        (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(content, style: theme.textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
  );

  return result ?? false;
}
