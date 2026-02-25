import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:ipr_s3/core/error/failures.dart';

abstract class DecryptFileBehavior {
  Future<Either<Failure, Uint8List>> decryptFile(String fileId);
}
