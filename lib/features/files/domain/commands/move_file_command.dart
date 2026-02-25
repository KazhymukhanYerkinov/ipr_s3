import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/commands/file_command.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class MoveFileCommand implements FileCommand {
  final FilesLocalSource _source;
  final SecureFileEntity _file;
  final String? _targetFolderId;

  String? _previousFolderId;

  MoveFileCommand(this._source, this._file, this._targetFolderId);

  @override
  String get description => 'Move "${_file.name}"';

  @override
  Future<void> execute() async {
    _previousFolderId = _file.folderId;
    final updated = _file.copyWith(folderId: _targetFolderId);
    await _source.save(updated);
  }

  @override
  Future<void> undo() async {
    final restored = _file.copyWith(folderId: _previousFolderId);
    await _source.save(restored);
  }
}
