import 'package:flutter/material.dart';
import 'package:ipr_s3/features/settings/presentation/widgets/battery_row.dart';
import 'package:ipr_s3/features/settings/presentation/widgets/storage_section.dart';

class DeviceInfoCard extends StatelessWidget {
  final int? batteryLevel;
  final int? freeStorage;
  final int? totalStorage;
  final ThemeData theme;

  const DeviceInfoCard({
    super.key,
    required this.batteryLevel,
    required this.freeStorage,
    required this.totalStorage,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final usedStorage =
        (totalStorage != null && freeStorage != null)
            ? totalStorage! - freeStorage!
            : null;
    final usagePercent =
        (totalStorage != null && usedStorage != null && totalStorage! > 0)
            ? usedStorage / totalStorage!
            : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BatteryRow(level: batteryLevel, theme: theme),
            const Divider(height: 24),
            StorageSection(
              freeStorage: freeStorage,
              totalStorage: totalStorage,
              usagePercent: usagePercent,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}
