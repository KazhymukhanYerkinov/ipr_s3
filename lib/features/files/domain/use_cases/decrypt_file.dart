import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart';

@lazySingleton
class DecryptFileUseCase {
  final DecryptFileBehavior _behavior;

  DecryptFileUseCase(this._behavior);

  Future<Either<Failure, Uint8List>> call(String fileId) async {
    return _behavior.decryptFile(fileId);
  }
}
