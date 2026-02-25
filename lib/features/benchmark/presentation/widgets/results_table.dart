import 'package:flutter/material.dart';
import 'package:ipr_s3/features/benchmark/domain/models/benchmark_result.dart';

class ResultsTable extends StatelessWidget {
  final List<BenchmarkResult> results;
  final ThemeData theme;

  const ResultsTable({super.key, required this.results, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          children: [
            _headerCell('Size', theme),
            _headerCell('Dart', theme),
            _headerCell('C (FFI)', theme),
            _headerCell('C+Isolate', theme),
            _headerCell('Speedup', theme),
          ],
        ),
        ...results.map(
          (r) => TableRow(
            children: [
              _dataCell('${r.sizeMb} MB', theme),
              _dataCell('${r.dartMs} ms', theme),
              _dataCell('${r.nativeMs} ms', theme, highlight: true),
              _dataCell('${r.isolateMs} ms', theme),
              _dataCell(
                '${r.speedup.toStringAsFixed(1)}x',
                theme,
                highlight: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _dataCell(String text, ThemeData theme, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          color:
              highlight
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
