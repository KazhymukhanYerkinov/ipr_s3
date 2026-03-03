import 'dart:typed_data';

import 'package:ipr_s3/core/result/result.dart';

abstract class LoadThumbnailBehavior {
  Future<Result<Uint8List>> loadThumbnail(String thumbnailPath);
}
