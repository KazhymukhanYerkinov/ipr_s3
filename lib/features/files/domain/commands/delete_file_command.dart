import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/commands/file_command.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class DeleteFileCommand implements FileCommand {
  final FilesLocalSource _source;
  final SecureFileEntity _file;

  SecureFileEntity? _backup;

  DeleteFileCommand(this._source, this._file);

  @override
  String get description => 'Delete "${_file.name}"';

  @override
  Future<void> execute() async {
    _backup = _file;
    await _source.delete(_file.id);
  }

  @override
  Future<void> undo() async {
    if (_backup != null) {
      await _source.save(_backup!);
    }
  }
}
