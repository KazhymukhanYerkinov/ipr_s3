import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/decrypt_file_behavior.dart';

@injectable
class DecryptFileUseCase implements Callable<String, Uint8List> {
  final DecryptFileBehavior _behavior;

  DecryptFileUseCase(this._behavior);

  @override
  Future<Result<Uint8List>> call(String fileId) {
    return _behavior.decryptFile(fileId);
  }
}
