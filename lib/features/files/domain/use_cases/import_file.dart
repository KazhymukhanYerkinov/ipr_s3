import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

@lazySingleton
class ImportFileUseCase {
  final FilesBehavior _filesBehavior;

  ImportFileUseCase(this._filesBehavior);

  Future<Either<Failure, SecureFileEntity>> call({
    required String name,
    required Uint8List bytes,
    required FileType type,
  }) async {
    return _filesBehavior.importFile(name: name, bytes: bytes, type: type);
  }
}
