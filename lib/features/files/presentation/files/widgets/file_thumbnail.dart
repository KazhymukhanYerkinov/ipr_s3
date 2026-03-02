import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ipr_s3/core/di/injection.dart';
import 'package:ipr_s3/features/files/data/services/file_encryption_service.dart';
import 'package:ipr_s3/features/files/data/sources/files_local_source.dart';
import 'package:ipr_s3/features/files/presentation/files/widgets/file_icon.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

class FileThumbnail extends StatefulWidget {
  static final _cache = <String, Uint8List>{};

  static void evict(String path) => _cache.remove(path);
  static void clearCache() => _cache.clear();

  final String thumbnailPath;
  final FileType fileType;
  final double iconSize;
  final BoxFit fit;

  const FileThumbnail({
    super.key,
    required this.thumbnailPath,
    required this.fileType,
    this.iconSize = 24,
    this.fit = BoxFit.cover,
  });

  @override
  State<FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<FileThumbnail> {
  Uint8List? _bytes;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final cached = FileThumbnail._cache[widget.thumbnailPath];
    if (cached != null) {
      _bytes = cached;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final localSource = getIt<FilesLocalSource>();
      final encryptionService = getIt<FileEncryptionService>();

      final encrypted = await localSource.readThumbnail(widget.thumbnailPath);
      if (encrypted == null || !mounted) return;

      final decrypted = await encryptionService.decrypt(encrypted);
      FileThumbnail._cache[widget.thumbnailPath] = decrypted;
      if (mounted) {
        setState(() => _bytes = decrypted);
      }
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        fit: widget.fit,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }

    if (_failed) return _fallbackIcon();

    return _fallbackIcon();
  }

  Widget _fallbackIcon() =>
      Center(child: FileIcon(type: widget.fileType, size: widget.iconSize));
}
