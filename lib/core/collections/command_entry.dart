import 'dart:collection';

import 'package:ipr_s3/features/files/domain/commands/file_command.dart';

/// LinkedListEntry-обёртка для [FileCommand].
///
/// Dart LinkedList требует, чтобы элементы расширяли LinkedListEntry.
/// Используется в CommandManager для undo/redo стеков —
/// O(1) добавление/удаление с конца.
base class CommandEntry extends LinkedListEntry<CommandEntry> {
  final FileCommand command;

  CommandEntry(this.command);
}
