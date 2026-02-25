import 'package:flutter/material.dart';

class BatteryRow extends StatelessWidget {
  final int? level;
  final ThemeData theme;

  const BatteryRow({
    super.key,
    required this.level,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final displayLevel = level != null ? '$level%' : 'N/A';

    IconData icon;
    Color color;
    if (level == null) {
      icon = Icons.battery_unknown_rounded;
      color = theme.colorScheme.onSurfaceVariant;
    } else if (level! <= 15) {
      icon = Icons.battery_alert_rounded;
      color = theme.colorScheme.error;
    } else if (level! <= 50) {
      icon = Icons.battery_3_bar_rounded;
      color = Colors.orange;
    } else {
      icon = Icons.battery_full_rounded;
      color = Colors.green;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Battery', style: theme.textTheme.bodyLarge),
        ),
        Text(
          displayLevel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
