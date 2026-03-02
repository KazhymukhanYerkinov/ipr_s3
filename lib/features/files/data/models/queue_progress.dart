import 'dart:typed_data';

class QueueProgress {
  final String fileId;
  final String fileName;
  final int completedCount;
  final int totalCount;
  final bool isComplete;
  final Uint8List? encryptedData;

  const QueueProgress({
    required this.fileId,
    required this.fileName,
    required this.completedCount,
    required this.totalCount,
    required this.isComplete,
    this.encryptedData,
  });

  double get progress => totalCount > 0 ? completedCount / totalCount : 0;
}
