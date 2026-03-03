import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:ipr_s3/core/error/failures.dart';
import 'package:ipr_s3/core/result/result.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/domain/behaviors/load_thumbnail_behavior.dart';

@LazySingleton(as: LoadThumbnailBehavior)
class ThumbnailCacheService implements LoadThumbnailBehavior {
  final FilesLocalSource _localSource;
  final FileEncryptionService _encryptionService;
  final _cache = <String, Uint8List>{};

  ThumbnailCacheService(this._localSource, this._encryptionService);

  @override
  Future<Result<Uint8List>> loadThumbnail(String thumbnailPath) async {
    try {
      final cached = _cache[thumbnailPath];
      if (cached != null) return SuccessResult(cached);

      final encrypted = await _localSource.readThumbnail(thumbnailPath);
      if (encrypted == null) {
        return ErrorResult(const FileFailure(message: 'Thumbnail not found'));
      }

      final decrypted = await _encryptionService.decrypt(encrypted);
      _cache[thumbnailPath] = decrypted;
      return SuccessResult(decrypted);
    } catch (e) {
      return ErrorResult(
        const EncryptionFailure(message: 'Failed to load thumbnail'),
      );
    }
  }

  void evict(String path) => _cache.remove(path);

  void clearCache() => _cache.clear();
}
