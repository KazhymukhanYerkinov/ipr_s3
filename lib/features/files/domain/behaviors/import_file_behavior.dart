import 'dart:typed_data';

import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class ImportFileBehavior {
  Future<Result<SecureFileEntity>> importFile({
    required String name,
    required Uint8List bytes,
    required FileType type,
    String? folderId,
  });
}
