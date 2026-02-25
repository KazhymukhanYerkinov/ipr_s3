import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const SectionHeader({super.key, required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
