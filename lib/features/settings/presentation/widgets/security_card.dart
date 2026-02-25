import 'package:flutter/material.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';

class SecurityCard extends StatelessWidget {
  final bool hasPin;
  final ThemeData theme;
  final VoidCallback onChangePin;

  const SecurityCard({
    super.key,
    required this.hasPin,
    required this.theme,
    required this.onChangePin,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.locale;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.lock_outline_rounded,
                color: theme.colorScheme.primary),
            title: Text(l.changePin),
            subtitle: Text(hasPin ? l.pinIsSet : l.noPinSet),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: hasPin ? onChangePin : null,
          ),
        ],
      ),
    );
  }
}
