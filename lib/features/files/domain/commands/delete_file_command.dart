import 'dart:typed_data';

import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/commands/file_command.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class DeleteFileCommand implements FileCommand {
  final FilesLocalSource _source;
  final SecureFileEntity _file;

  SecureFileEntity? _backup;
  Uint8List? _encryptedBytes;
  Uint8List? _thumbnailBytes;

  DeleteFileCommand(this._source, this._file);

  @override
  String get description => 'Delete "${_file.name}"';

  @override
  Future<void> execute() async {
    _backup = _file;
    _encryptedBytes = await _source.readEncryptedFile(_file.encryptedPath);
    if (_file.thumbnailPath != null) {
      _thumbnailBytes = await _source.readThumbnail(_file.thumbnailPath!);
    }
    await _source.delete(_file.id);
  }

  @override
  Future<void> undo() async {
    if (_backup == null) return;

    if (_encryptedBytes != null) {
      await _source.saveEncryptedFile(_backup!.id, _encryptedBytes!);
    }
    if (_thumbnailBytes != null && _backup!.thumbnailPath != null) {
      await _source.saveThumbnail(_backup!.id, _thumbnailBytes!);
    }
    await _source.save(_backup!);
  }
}
