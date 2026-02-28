import 'dart:collection';

import 'package:ipr_s3/features/files/domain/commands/file_command.dart';

base class CommandEntry extends LinkedListEntry<CommandEntry> {
  final FileCommand command;

  CommandEntry(this.command);
}
