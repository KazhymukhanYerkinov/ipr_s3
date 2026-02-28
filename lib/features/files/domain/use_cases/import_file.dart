import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class ImportFileParams {
  final String name;
  final Uint8List bytes;
  final FileType type;
  final String? folderId;

  ImportFileParams({
    required this.name,
    required this.bytes,
    required this.type,
    this.folderId,
  });
}

@injectable
class ImportFileUseCase
    implements Callable<ImportFileParams, SecureFileEntity> {
  final ImportFileBehavior _behavior;

  ImportFileUseCase(this._behavior);

  @override
  Future<Result<SecureFileEntity>> call(ImportFileParams params) {
    return _behavior.importFile(
      name: params.name,
      bytes: params.bytes,
      type: params.type,
      folderId: params.folderId,
    );
  }
}
