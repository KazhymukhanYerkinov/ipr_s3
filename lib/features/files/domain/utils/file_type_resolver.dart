import 'package:ipr_s3/features/files/domain/models/secure_file_entity.dart';

abstract class FileTypeResolver {
  static const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'};
  static const _pdfExtensions = {'pdf'};
  static const _textExtensions = {'txt', 'md', 'json', 'xml', 'csv', 'log'};
  static const _videoExtensions = {'mp4', 'mov', 'avi', 'mkv'};
  static const _audioExtensions = {'mp3', 'wav', 'aac', 'flac'};

  static FileType fromExtension(String? extension) {
    if (extension == null) return FileType.unknown;
    final ext = extension.toLowerCase();
    if (_imageExtensions.contains(ext)) return FileType.image;
    if (_pdfExtensions.contains(ext)) return FileType.pdf;
    if (_textExtensions.contains(ext)) return FileType.text;
    if (_videoExtensions.contains(ext)) return FileType.video;
    if (_audioExtensions.contains(ext)) return FileType.audio;
    return FileType.unknown;
  }
}
