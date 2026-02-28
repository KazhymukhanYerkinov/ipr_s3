import 'dart:typed_data';

import 'package:ipr_s3/core/result/result.dart';

abstract class DecryptFileBehavior {
  Future<Result<Uint8List>> decryptFile(String fileId);
}
