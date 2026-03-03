import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/core/use_case/callable.dart';
import 'package:ipr_s3/features/files/domain/behaviors/load_thumbnail_behavior.dart';

@injectable
class LoadThumbnailUseCase implements Callable<String, Uint8List> {
  final LoadThumbnailBehavior _behavior;

  LoadThumbnailUseCase(this._behavior);

  @override
  Future<Result<Uint8List>> call(String thumbnailPath) {
    return _behavior.loadThumbnail(thumbnailPath);
  }
}
