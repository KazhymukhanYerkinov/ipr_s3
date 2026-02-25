import 'package:flutter/material.dart';

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
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.lock_outline_rounded,
                color: theme.colorScheme.primary),
            title: const Text('Change PIN'),
            subtitle: Text(hasPin ? 'PIN is set' : 'No PIN set'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: hasPin ? onChangePin : null,
          ),
        ],
      ),
    );
  }
}
