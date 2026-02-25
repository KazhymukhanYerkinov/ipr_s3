import 'dart:collection';

import 'package:ipr_s3/core/collections/command_entry.dart';
import 'package:ipr_s3/features/files/domain/commands/file_command.dart';

/// Менеджер Undo/Redo для файловых операций.
///
/// Хранит историю в двух [LinkedList]:
/// - _undoStack — выполненные команды (отменяются по LIFO)
/// - _redoStack — отменённые команды (повторяются по LIFO)
///
/// LinkedList выбран вместо List, потому что:
/// - O(1) добавление/удаление с конца (vs O(n) для List при removeLast)
/// - Элементы хранят ссылки на соседей — нет сдвигов массива
/// - Демонстрация Цели 6 (LinkedList из dart:collection)
class CommandManager {
  final LinkedList<CommandEntry> _undoStack = LinkedList<CommandEntry>();
  final LinkedList<CommandEntry> _redoStack = LinkedList<CommandEntry>();

  static const int _maxHistorySize = 50;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  List<String> get undoHistory =>
      _undoStack.map((e) => e.command.description).toList().reversed.toList();

  Future<void> execute(FileCommand command) async {
    await command.execute();
    _undoStack.add(CommandEntry(command));
    _redoStack.clear();

    if (_undoStack.length > _maxHistorySize) {
      _undoStack.first.unlink();
    }
  }

  Future<void> undo() async {
    if (!canUndo) return;

    final entry = _undoStack.last;
    entry.unlink();
    await entry.command.undo();
    _redoStack.add(CommandEntry(entry.command));
  }

  Future<void> redo() async {
    if (!canRedo) return;

    final entry = _redoStack.last;
    entry.unlink();
    await entry.command.execute();
    _undoStack.add(CommandEntry(entry.command));
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
