import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/image_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/pdf_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/text_preview.dart';
import 'package:ipr_s3/features/files/presentation/widgets/previews/unknown_preview.dart';

abstract class FilePreviewFactory {
  static Widget create({
    required SecureFileEntity file,
    required Uint8List bytes,
  }) {
    return switch (file.type) {
      FileType.image => ImagePreview(bytes: bytes),
      FileType.pdf => PdfPreview(bytes: bytes),
      FileType.text => TextPreview(bytes: bytes),
      FileType.video ||
      FileType.audio ||
      FileType.unknown => UnknownPreview(file: file),
    };
  }
}
