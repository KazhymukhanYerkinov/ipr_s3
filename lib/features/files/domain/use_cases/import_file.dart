import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/import_file_behavior.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

@lazySingleton
class ImportFileUseCase {
  final ImportFileBehavior _behavior;

  ImportFileUseCase(this._behavior);

  Future<Either<Failure, SecureFileEntity>> call({
    required String name,
    required Uint8List bytes,
    required FileType type,
  }) async {
    return _behavior.importFile(name: name, bytes: bytes, type: type);
  }
}
