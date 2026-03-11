import 'dart:convert';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

class CommandPanel extends StatefulWidget {
  const CommandPanel({super.key});

  @override
  State<CommandPanel> createState() => _CommandPanelState();
}

class _CommandPanelState extends State<CommandPanel> {
  bool _loading = true;
  String? _error;

  List<String> _undoStack = [];
  List<String> _redoStack = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await serviceManager.callServiceExtensionOnMainIsolate(
        'ext.filesecure.getCommandHistory',
      );

      final data = response.json ?? {};
      final Map<String, dynamic> result;
      if (data['result'] is String) {
        result = jsonDecode(data['result'] as String) as Map<String, dynamic>;
      } else if (data['result'] is Map) {
        result = Map<String, dynamic>.from(data['result'] as Map);
      } else {
        result = data;
      }

      setState(() {
        _undoStack = List<String>.from(result['undoStack'] as List? ?? []);
        _redoStack = List<String>.from(result['redoStack'] as List? ?? []);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 12),
            Text(
              'Failed to fetch command history',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_error!, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _fetchHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final hasHistory = _undoStack.isNotEmpty || _redoStack.isNotEmpty;

    return RefreshIndicator(
      onRefresh: _fetchHistory,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderRow(
            undoCount: _undoStack.length,
            redoCount: _redoStack.length,
            onRefresh: _fetchHistory,
          ),
          const SizedBox(height: 16),
          if (!hasHistory)
            const _EmptyState()
          else ...[
            if (_undoStack.isNotEmpty) ...[
              _StackSection(
                title: 'Undo Stack (LinkedList)',
                icon: Icons.undo,
                color: Colors.blue,
                items: _undoStack,
              ),
              const SizedBox(height: 16),
            ],
            if (_redoStack.isNotEmpty)
              _StackSection(
                title: 'Redo Stack (LinkedList)',
                icon: Icons.redo,
                color: Colors.orange,
                items: _redoStack,
              ),
          ],
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final int undoCount;
  final int redoCount;
  final VoidCallback onRefresh;

  const _HeaderRow({
    required this.undoCount,
    required this.redoCount,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CountBadge(label: 'Undo', count: undoCount, color: Colors.blue),
        const SizedBox(width: 8),
        _CountBadge(label: 'Redo', count: redoCount, color: Colors.orange),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.refresh, size: 20),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StackSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _StackSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...List.generate(items.length, (index) {
          final isTop = index == items.length - 1;
          return _CommandTile(
            index: index,
            description: items[index],
            color: color,
            isTop: isTop,
          );
        }),
      ],
    );
  }
}

class _CommandTile extends StatelessWidget {
  final int index;
  final String description;
  final Color color;
  final bool isTop;

  const _CommandTile({
    required this.index,
    required this.description,
    required this.color,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              isTop
                  ? color.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.2),
          width: isTop ? 1.5 : 1.0,
        ),
      ),
      color: isTop ? color.withValues(alpha: 0.05) : null,
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: color.withValues(alpha: isTop ? 0.2 : 0.08),
          child: Text(
            '${index + 1}',
            style: TextStyle(fontSize: 11, color: color),
          ),
        ),
        title: Text(description, style: const TextStyle(fontSize: 13)),
        trailing:
            isTop
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'TOP',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 56,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'No commands executed yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Text(
              'Delete, move or rename files to see the command history',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
