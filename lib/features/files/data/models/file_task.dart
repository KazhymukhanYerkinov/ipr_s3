import 'dart:typed_data';

class FileTask {
  final String fileId;
  final String fileName;
  final Uint8List data;

  const FileTask({
    required this.fileId,
    required this.fileName,
    required this.data,
  });
}
