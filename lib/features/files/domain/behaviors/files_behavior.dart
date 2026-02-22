import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';

abstract class FilesBehavior {
  Future<Either<Failure, List<SecureFileEntity>>> getFiles();
  Future<Either<Failure, SecureFileEntity>> importFile({
    required String name,
    required Uint8List bytes,
    required FileType type,
  });
  Future<Either<Failure, Uint8List>> decryptFile(String fileId);
  Future<Either<Failure, void>> deleteFile(String fileId);
  Future<Either<Failure, List<SecureFileEntity>>> searchFiles(String query);
}
