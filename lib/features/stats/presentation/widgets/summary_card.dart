import 'package:flutter/material.dart';
import 'package:ipr_s3/core/utils/format_utils.dart';
import 'package:ipr_s3/features/stats/presentation/widgets/stat_item.dart';

class SummaryCard extends StatelessWidget {
  final int totalFiles;
  final int totalSize;
  final ThemeData theme;

  const SummaryCard({
    super.key,
    required this.totalFiles,
    required this.totalSize,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: StatItem(
                label: 'Total Files',
                value: '$totalFiles',
                icon: Icons.insert_drive_file_outlined,
                theme: theme,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: theme.colorScheme.outlineVariant,
            ),
            Expanded(
              child: StatItem(
                label: 'Total Size',
                value: formatSize(totalSize),
                icon: Icons.storage_outlined,
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
