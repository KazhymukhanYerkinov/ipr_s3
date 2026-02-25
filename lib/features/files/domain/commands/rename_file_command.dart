import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/commands/file_command.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class RenameFileCommand implements FileCommand {
  final FilesLocalSource _source;
  final SecureFileEntity _file;
  final String _newName;

  late final String _oldName;

  RenameFileCommand(this._source, this._file, this._newName);

  @override
  String get description => 'Rename "${_file.name}" → "$_newName"';

  @override
  Future<void> execute() async {
    _oldName = _file.name;
    final updated = _file.copyWith(name: _newName, updatedAt: DateTime.now());
    await _source.save(updated);
  }

  @override
  Future<void> undo() async {
    final restored = _file.copyWith(name: _oldName, updatedAt: DateTime.now());
    await _source.save(restored);
  }
}
