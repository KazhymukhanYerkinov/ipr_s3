import 'package:flutter/material.dart';
import 'package:ipr_s3/core/collections/tag.dart';

/// Виджет для отображения и управления тегами файла.
///
/// Использует [Set<Tag>] — дубликаты исключаются автоматически
/// благодаря кастомным [operator==] и [hashCode] в [Tag].
class TagChipsWidget extends StatefulWidget {
  final Set<Tag> tags;
  final ValueChanged<Set<Tag>> onTagsChanged;

  const TagChipsWidget({
    super.key,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<TagChipsWidget> createState() => _TagChipsWidgetState();
}

class _TagChipsWidgetState extends State<TagChipsWidget> {
  late Set<Tag> _tags;

  @override
  void initState() {
    super.initState();
    _tags = Set<Tag>.from(widget.tags);
  }

  @override
  void didUpdateWidget(covariant TagChipsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags != widget.tags) {
      _tags = Set<Tag>.from(widget.tags);
    }
  }

  void _addTag(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _tags.add(Tag(trimmed));
    });
    widget.onTagsChanged(_tags);
  }

  void _removeTag(Tag tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged(_tags);
  }

  void _showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Tag name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) {
              _addTag(value);
              Navigator.pop(dialogContext);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                _addTag(controller.text);
                Navigator.pop(dialogContext);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).then((_) => controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        ..._tags.map(
          (tag) => Chip(
            label: Text(tag.name),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () => _removeTag(tag),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        ActionChip(
          avatar: Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
          label: const Text('Add tag'),
          onPressed: _showAddDialog,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
