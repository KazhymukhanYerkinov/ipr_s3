import 'package:flutter/material.dart';

extension SnackBarX on BuildContext {
  void showFloatingSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: duration,
          action: action,
        ),
      );
  }
}
