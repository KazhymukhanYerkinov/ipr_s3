import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/entities/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/image_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/pdf_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/text_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/unknown_preview.dart';

/// Factory pattern — returns the appropriate preview widget
/// based on the file type. Easily extensible for new formats.
abstract class FilePreviewFactory {
  static Widget create({
    required SecureFileEntity file,
    required Uint8List bytes,
  }) {
    switch (file.type) {
      case FileType.image:
        return ImagePreview(bytes: bytes);
      case FileType.pdf:
        return PdfPreview(bytes: bytes);
      case FileType.text:
        return TextPreview(bytes: bytes);
      case FileType.video:
      case FileType.audio:
      case FileType.unknown:
        return UnknownPreview(file: file);
    }
  }
}
