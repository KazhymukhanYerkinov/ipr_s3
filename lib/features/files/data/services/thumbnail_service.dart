import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;
import 'package:ipr_s3/core/security/secure_logger.dart';

class ThumbnailParams {
  final Uint8List imageBytes;
  final int maxWidth;
  final int maxHeight;

  const ThumbnailParams({
    required this.imageBytes,
    this.maxWidth = 200,
    this.maxHeight = 200,
  });
}

/// Top-level function for compute() — resizes an image to create a thumbnail.
Uint8List? generateThumbnail(ThumbnailParams params) {
  final image = img.decodeImage(params.imageBytes);
  if (image == null) return null;

  final thumbnail = img.copyResize(
    image,
    width: params.maxWidth,
    height: params.maxHeight,
    maintainAspect: true,
  );

  return Uint8List.fromList(img.encodePng(thumbnail));
}

/// Service that generates image thumbnails in a background isolate
/// via compute(), preventing jank on the UI thread.
@lazySingleton
class ThumbnailService {
  final _logger = SecureLogger();

  Future<Uint8List?> create(Uint8List imageBytes) async {
    _logger.info('Generating thumbnail in background isolate');
    try {
      return await compute(
        generateThumbnail,
        ThumbnailParams(imageBytes: imageBytes),
      );
    } catch (e, stackTrace) {
      _logger.error('Thumbnail generation failed', e, stackTrace);
      return null;
    }
  }
}
