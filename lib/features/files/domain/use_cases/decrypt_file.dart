import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/files_behavior.dart';

@lazySingleton
class DecryptFileUseCase {
  final FilesBehavior _filesBehavior;

  DecryptFileUseCase(this._filesBehavior);

  Future<Either<Failure, Uint8List>> call(String fileId) async {
    return _filesBehavior.decryptFile(fileId);
  }
}
