import 'package:flutter/material.dart';
import 'package:ipr_s3/core/collections/tag.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';

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
    final l = context.locale;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l.addTag),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l.tagName,
              border: const OutlineInputBorder(),
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
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () {
                _addTag(controller.text);
                Navigator.pop(dialogContext);
              },
              child: Text(l.add),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.locale;

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
          label: Text(l.addTagChip),
          onPressed: _showAddDialog,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
